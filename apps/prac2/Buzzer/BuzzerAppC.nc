/**
 * 
 * Button demo application.
 * 
 * @author Philipp Sommer
 */

configuration BuzzerAppC 
{ 
} 
implementation { 
  
  components BuzzerC, MainC, LedsC, new TimerMilliC();
  BuzzerC.Boot -> MainC;
  BuzzerC.Leds -> LedsC;
  BuzzerC.Timer -> TimerMilliC;

  components ZigduinoDigitalPortsC;
  BuzzerC.Button -> ZigduinoDigitalPortsC.Digital1;
  BuzzerC.GpioInterrupt -> ZigduinoDigitalPortsC.Interrupt1;

  BuzzerC.Buzzer -> ZigduinoDigitalPortsC.Digital2;
}
