/**
 * 
 * TimeSync demo application.
 * 
 * @author Philipp Sommer (CSIRO ICT Centre)
 */


#include "printf.h"

module BlinkTimeSyncC
{
  uses {
    interface Boot;
    interface Leds;
    interface RgbLed;
    
    interface Timer<TMilli> as BlinkTimer;

    interface SplitControl as RadioControl;
    interface StdControl as TimeSyncControl;
    interface LocalTime<TMilli>;
    interface GlobalTime<TMilli>;
  }
}

implementation
{

  uint32_t refLocalTime = 0;
  uint32_t refGlobalTime = 0;
 
  event void Boot.booted() {

    printf("Booted\n");
    printfflush();

    // start radio
    call RadioControl.start();

    // switch off all Leds
    call Leds.set(0);
    call RgbLed.setColorRgb(0, 0, 0);

    // start timer to toggle LEDs
    call BlinkTimer.startOneShot(1);
  }
  
  event void RadioControl.startDone(error_t error) {
  
    // start timesync service
    call TimeSyncControl.start();
  }


  event void BlinkTimer.fired() {

    uint32_t diff = 0;
    uint32_t gs = 0;
    
    call GlobalTime.getGlobalTime(&refGlobalTime);

    diff = 1000 - ((refGlobalTime+500) % 1000);

    call BlinkTimer.startOneShot( diff );
    
    gs = (refGlobalTime/1000) & 7;
    
    call RgbLed.setColorRgb(128 * ((gs & 0x04) >> 2),
                            128 * ((gs & 0x02) >> 1),
                            128 * (gs & 0x01));

    call Leds.set(0);
    call Leds.set(1 << ((refGlobalTime/1000) % 3));

  }

  event void RadioControl.stopDone(error_t error) {}
 
}

