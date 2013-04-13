/*
 * Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the copyright holders nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#include <lib6lowpan/lib6lowpan.h>
#include "Timer.h"

configuration TCPEchoC {

} implementation {
  components MainC, LedsC;
  components TCPEchoP;

  TCPEchoP.Boot -> MainC;

  components new TimerMilliC();
  components IPDispatchC, IPStackC;

  TCPEchoP.RadioControl -> IPStackC;
  components new UdpSocketC() as Echo,
    new UdpSocketC() as Status;
  TCPEchoP.Echo -> Echo;

  components new TcpSocketC() as TcpEcho;
  TCPEchoP.TcpEcho -> TcpEcho;

  components new TcpSocketC() as TcpWeb, HttpdP;
  HttpdP.Boot -> MainC;
  HttpdP.Leds -> LedsC;
  HttpdP.Tcp -> TcpWeb;

  components new TimerMilliC() as Timer_delay;
  HttpdP.Timer_delay -> Timer_delay;
	
  TCPEchoP.Status -> Status;

  TCPEchoP.StatusTimer -> TimerMilliC;

  components UdpC;

  TCPEchoP.IPStats -> IPDispatchC;
  TCPEchoP.UDPStats -> UdpC;

  components RandomC;
  TCPEchoP.Random -> RandomC;

  components UDPShellC;

  components new LightC(), new TempC();
  HttpdP.TempSensor -> TempC;
  HttpdP.LightSensor -> LightC;

#ifdef RPL_ROUTING
  components RPLRoutingC;
#endif


  // prints the routing table
#if defined(PLATFORM_IRIS)
#warning *** RouterCmd disabled for IRIS ***
#else
  components RouteCmdC;
#endif

#ifndef  IN6_PREFIX
  components DhcpCmdC;
#endif

#ifdef PRINTFUART_ENABLED
  /* This component wires printf directly to the serial port, and does
   * not use any framing.  You can view the output simply by tailing
   * the serial device.  Unlike the old printfUART, this allows us to
   * use PlatformSerialC to provide the serial driver.
   * 
   * For instance:
   * $ stty -F /dev/ttyUSB0 115200
   * $ tail -f /dev/ttyUSB0
  */
  components SerialPrintfC;

#endif


}
