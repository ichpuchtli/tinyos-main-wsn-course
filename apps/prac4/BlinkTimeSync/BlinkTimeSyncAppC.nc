/**
 * 
 * TimeSync demo application.
 * 
 * @author Philipp Sommer (CSIRO ICT Centre)
 */


configuration BlinkTimeSyncAppC 
{ 
} 
implementation { 
  
  components BlinkTimeSyncC, MainC, new TimerMilliC() as BlinkTimerMilli;

  BlinkTimeSyncC.Boot -> MainC;
  BlinkTimeSyncC.BlinkTimer -> BlinkTimerMilli;
  
  
  components LedsC, new RgbLedC(6, 7);
  BlinkTimeSyncC.Leds -> LedsC;
  BlinkTimeSyncC.RgbLed -> RgbLedC;
  
  components IPStackC;
  BlinkTimeSyncC.RadioControl ->  IPStackC;

#ifdef RPL_ROUTING
  components RPLRoutingC;
#endif

  // UDP shell on port 2000
  components UDPShellC;
  components RouteCmdC;

  // printf on serial port
  components SerialPrintfC, SerialStartC;

  components LocalTimeMilliC;
  BlinkTimeSyncC.LocalTime -> LocalTimeMilliC;
  
  components TimeSyncC;
  MainC.SoftwareInit -> TimeSyncC;
  BlinkTimeSyncC.TimeSyncControl -> TimeSyncC;
  BlinkTimeSyncC.GlobalTime -> TimeSyncC;
}

