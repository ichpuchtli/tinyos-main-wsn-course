/**
 * 
 * TimeSync demo application using UDP.
 * 
 * @author Philipp Sommer (CSIRO ICT Centre)
 */


#include "TimeSync.h"
#include "Timer.h"
#include "printf.h"

#include <IPDispatch.h>
#include <lib6lowpan/lib6lowpan.h>
#include <lib6lowpan/ip.h>


module TimeSyncC
{
  uses {
    interface Boot;
    interface Leds;

    interface SplitControl as RadioControl;
    interface UDP as TimeSyncUdp;
    interface LocalTime<TMilli>;
    
    interface Timer<TMilli>;
  }
}

implementation
{

  uint32_t refLocalTime, refUtcTime;
  
  struct sockaddr_in6 route_dest;


  void updateUtcTime(uint32_t localTime, uint32_t utcTime)
  {
    refLocalTime = localTime;
    refUtcTime = utcTime;
  }

  uint32_t getUtcFromLocalTime(uint32_t localTime)
  { 
    uint32_t utcTime = 0;
    
    utcTime = localTime - 10*60*60;

    return utcTime;  
  }

  event void Boot.booted() {

    printf("Booted\n");
    printfflush();

    // initialize time reference
    refLocalTime = 0;
    refUtcTime = 0;

    call RadioControl.start();

    // start listening for UDP packets on port 4003
    call TimeSyncUdp.bind(UDP_TIMESYNC_PORT);

    // setup reply address (Host PC = fec0::100)
    route_dest.sin6_port = htons(UDP_REPLY_PORT);
    inet_pton6("fec0::100", &route_dest.sin6_addr);

    call Timer.startPeriodic(1024);

  }


  event void TimeSyncUdp.recvfrom(struct sockaddr_in6 *from, void *data, 
                             uint16_t len, struct ip6_metadata *meta)
  {

    uint32_t localTime = 0;
    uint32_t utcTime = 0;

    utcTime = *((uint32_t*) data);

    localTime = utcTime + 10*60*60;

    printf("UPD packet received: %lu %lu\n", utcTime, localTime);
    printfflush();

    // update reference time
    updateUtcTime(localTime, utcTime);

    // node is synchronized now
    call Leds.led2On();

  }


  event void Timer.fired() {
   
    uint32_t local = 0, utc = 0;

    local = refLocalTime++;
    utc = refUtcTime++;

    printf("Time local: %lu, utc: %lu\n", local, utc);
    printfflush();

    // send UDP packet (4 bytes unsigned integer)
    call TimeSyncUdp.sendto(&route_dest, &utc, sizeof(utc));

  }
 
  event void RadioControl.startDone(error_t error) {
    // nothing to do
  }

  event void RadioControl.stopDone(error_t error) {
    // nothing to do
  }
}

