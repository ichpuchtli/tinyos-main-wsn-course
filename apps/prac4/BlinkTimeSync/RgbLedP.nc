generic module RgbLedP() @safe()
{
  provides interface Init;
  provides interface RgbLed;
  
  uses interface GeneralIO as ClockPin;
  uses interface GeneralIO as DataPin;
}
implementation
{


  command error_t Init.init() {
  
    call ClockPin.makeOutput();
    call DataPin.makeOutput();

    return SUCCESS;
  }

  void sendByte(uint8_t data) {
  
    uint8_t i = 0;

    for(; i < 8; i++){

      if(data << i) call DataPin.set();
      else call DataPin.clr();

      call ClockPin.clr();
      call ClockPin.set();
    }

  
  }

  command void RgbLed.setColorRgb(uint8_t red, uint8_t green, uint8_t blue) {


    uint8_t flag = 0b11000000;

    flag |= (~red & 0xC0) >> 6;
    flag |= (~green & 0xC0) >> 4;
    flag |= (~blue & 0xC0) >> 2;

    sendByte(0);
    sendByte(0);
    sendByte(0);
    sendByte(0);

    sendByte(flag);
    sendByte(red);
    sendByte(green);
    sendByte(blue);

    sendByte(flag);
    sendByte(red);
    sendByte(green);
    sendByte(blue);

    sendByte(0);
    sendByte(0);
    sendByte(0);
    sendByte(0);
  }

}
