configuration BlinkAppC
{
}
implementation
{
  components MainC, BlinkC, new RgbLedC(6, 7), LedsC;
  components new TimerMilliC() as Timer0;


  BlinkC -> MainC.Boot;

  BlinkC.Timer0 -> Timer0;
  BlinkC.Leds -> LedsC;
  BlinkC.RgbLed -> RgbLedC;
}
