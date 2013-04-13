/**
 * 
 * TimeSync demo application using UDP.
 * 
 * @author Philipp Sommer (CSIRO ICT Centre)
 */

#include "TimeSync.h"

configuration TimeSyncAppC 
{ 
} 
implementation { 
  
  components TimeSyncC, MainC, LedsC, new TimerMilliC();

  TimeSyncC.Boot -> MainC;
  TimeSyncC.Leds -> LedsC;
  TimeSyncC.Timer -> TimerMilliC;

  components LocalTimeMilliC;
  TimeSyncC.LocalTime -> LocalTimeMilliC;

  components IPStackC;
  TimeSyncC.RadioControl ->  IPStackC;

#ifdef RPL_ROUTING
  components RPLRoutingC;
#endif

  components new UdpSocketC();
  TimeSyncC.TimeSyncUdp -> UdpSocketC;
  
  // UDP shell on port 2000
  components UDPShellC;
  components RouteCmdC;

  // printf on serial port
  components SerialPrintfC, SerialStartC;

}

