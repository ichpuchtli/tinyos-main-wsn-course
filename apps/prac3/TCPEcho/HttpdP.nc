
module HttpdP {
  uses {
    interface Leds;
    interface Boot;
    interface Tcp;
    interface Timer<TMilli> as Timer_delay;

    interface Read<uint16_t> as LightSensor;
    interface Read<int16_t> as TempSensor;
  }
} implementation {

  static char *http_okay = "HTTP/1.0 200 OK\r\n\r\n";
  static int http_okay_len = 19;

  uint16_t LightSensorValue;
  uint16_t TempSensorValue;
  float TempSensorCelciusValue;


  enum {
    S_IDLE,
    S_CONNECTED,
    S_REQUEST_PRE,
    S_REQUEST,
    S_HEADER,
    S_BODY,
  };

  enum {
    HTTP_GET,
    HTTP_POST,
  };

  event void LightSensor.readDone(error_t result, uint16_t data) 
  {
      if(result == SUCCESS) LightSensorValue = data;
  }

  event void TempSensor.readDone(error_t result, int16_t data) 
  {
      if(result == SUCCESS) TempSensorValue = data;
      TempSensorCelciusValue = 1.13 * ((float) data) - 272.8;
  }

  void process_request(int verb, char *request, int len) {
    char reply[24];
    uint8_t replylen;
    memcpy(reply, "led0: 0 led1: 0 led2: 0\n", 24);

#ifdef PRINTFUART_ENABLED
    printf("request: '%s'\n", request);
#endif

    call Tcp.send(http_okay, http_okay_len);

    if(len >= 8 && strstr(request, "/set/led0")){ 
      call Leds.led0On(); 
      replylen = sprintf(reply,"Led0On");
      goto SEND;
    }

    if(len >= 8 && strstr(request, "/set/led1")){ 
      call Leds.led1On(); 
      replylen = sprintf(reply,"Led1On");
      goto SEND;
    }

    if(len >= 8 && strstr(request, "/set/led2")){ 
      call Leds.led2On();   
      replylen = sprintf(reply,"Led2On");
      goto SEND;
    }

    if(len >= 8 && strstr(request, "/read/light")){ 
      replylen = sprintf(reply,"Light:%02u", LightSensorValue);
      goto SEND;
    }

    if(len >= 8 && strstr(request, "/read/temp")){ 
      replylen = sprintf(reply,"Temperature (Celcius):%02d", TempSensorCelciusValue);
      goto SEND;
    }

    if (len >= 8 && strstr(request, "/read/leds")){

        uint8_t bitmap = call Leds.get();

        if (bitmap & 1) reply[6] = '1';
        if (bitmap & 2) reply[14] = '1';
        if (bitmap & 4) reply[22] = '1';
        replylen = 24;

    }

SEND:
    call Tcp.send(reply, replylen);

    //Call delay timer, to close the TCP connection.
    call Timer_delay.startOneShot(2000);

  }

//Delay timer used to close the TCP connection.
event void Timer_delay.fired() {

	//close TCP connection.
	call Tcp.close();	
}

  int http_state;
  int req_verb;
  char request_buf[150], *request;
  char tcp_buf[100];

  event void Boot.booted() {
    http_state = S_IDLE;
    call Tcp.bind(80);
  }

  event bool Tcp.accept(struct sockaddr_in6 *from, 
                            void **tx_buf, int *tx_buf_len) {
    if (http_state == S_IDLE) {
      http_state = S_CONNECTED;
      *tx_buf = tcp_buf;
      *tx_buf_len = 100;
      return TRUE;
    }

#ifdef PRINTFUART_ENABLED
    printf("rejecting connection\n");
#endif

    return FALSE;
  }
  event void Tcp.connectDone(error_t e) {
    
  }
  event void Tcp.recv(void *payload, uint16_t len) {
    static int crlf_pos;
    char *msg = payload;
    switch (http_state) {
    case S_CONNECTED:
      crlf_pos = 0;
      request = request_buf;
      if (len < 3) {
        //call Tcp.close();
        return;
      }
      if (msg[0] == 'G') {
        req_verb = HTTP_GET;
        msg += 3;
        len -= 3;
      }
      http_state = S_REQUEST_PRE;
    case S_REQUEST_PRE:
      while (len > 0 && *msg == ' ') {
        len--; msg++;
      }
      if (len == 0) break;
      http_state = S_REQUEST;
    case S_REQUEST:
      while (len > 0 && *msg != ' ') {
        *request++ = *msg++;
        len--;
      }
      if (len == 0) break;
      *request++ = '\0';
      http_state = S_HEADER;
    case S_HEADER:
      while (len > 0) {
        switch (crlf_pos) {
        case 0:
        case 2:
          if (*msg == '\r') crlf_pos ++;
          else if (*msg == '\n') crlf_pos += 2;
          else crlf_pos = 0;
          break;
        case 1:
        case 3:
          if (*msg == '\n') crlf_pos ++;
          else crlf_pos = 0;
          break;
        }
        len--; msg++;
        // if crlf == 2, we just finished a header line.  you know.  fyi.
        if (crlf_pos == 4) {
          http_state = S_BODY;
			process_request(req_verb, request_buf, request - request_buf - 1);
          break;
        } 
      }
	break;
    if (crlf_pos <= 4) break;

    case S_BODY:
      // len might be zero here... just a note.
    default:
      //call Tcp.close();
    }
  }

  event void Tcp.closed(error_t e) {

    call Tcp.bind(80);
    http_state = S_IDLE;
  }

  event void Tcp.acked() {

     call LightSensor.read(); 
     call TempSensor.read(); 
  }
}
