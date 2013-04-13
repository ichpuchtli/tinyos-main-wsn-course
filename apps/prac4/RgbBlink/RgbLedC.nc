
generic configuration RgbLedC(uint8_t clockPin, uint8_t dataPin)
{
  provides interface RgbLed;
}

implementation
{
  
  components MainC, new RgbLedP();
  MainC.SoftwareInit -> RgbLedP;
  
  RgbLed = RgbLedP;
  
  components ZigduinoDigitalPortsC;
  RgbLedP.ClockPin -> ZigduinoDigitalPortsC.DigitalPin[clockPin];	//CLK;
  RgbLedP.DataPin -> ZigduinoDigitalPortsC.DigitalPin[dataPin];	//DATA;

}

