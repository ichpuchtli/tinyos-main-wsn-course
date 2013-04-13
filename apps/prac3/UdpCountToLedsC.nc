#include "Timer.h"
#include "UdpCountToLeds.h"
#include <IPDispatch.h>
#include "lib6lowpan/lib6lowpan.h"
#include <lib6lowpan/ip.h>

module UdpCountToLedsC {
  uses {
    interface Leds;
    interface Boot;
    interface Timer<TMilli> as MilliTimer;
    interface SplitControl as RadioControl;
    interface UDP as LedService;
  }
}
implementation {
 
  radio_count_msg_t radio_payload;
  uint8_t counter;
  struct sockaddr_in6 dest;
 
  event void Boot.booted() {
    call RadioControl.start();
  }
 
  event void RadioControl.startDone(error_t e) {
	call MilliTimer.startPeriodic(1000);
	call LedService.bind(1234);
  }
 
  event void RadioControl.stopDone(error_t e) { } //nothing to do
  event void LedService.recvfrom(struct sockaddr_in6 *src, void *payload, 
                      uint16_t len, struct ip6_metadata *meta)
  {   
    radio_count_msg_t * msg = payload;
    if(len == sizeof(radio_count_msg_t))
    {
        call Leds.set(msg->counter);
    }
  }
 
  event void MilliTimer.fired() {
	counter++;
	radio_payload.counter=counter;

        if(TOS_NODE_ID == 2){
          inet_pton6("fe80::22:ff:fe00:3", &dest.sin6_addr);
        }else if(TOS_NODE_ID == 3) {
          inet_pton6("fe80::22:ff:fe00:2", &dest.sin6_addr);
        }else{
          inet_pton6("ff02::8", &dest.sin6_addr);
        }

	dest.sin6_port = htons(1234);
	call LedService.sendto(&dest,&radio_payload,sizeof(radio_count_msg_t));
  }
}
