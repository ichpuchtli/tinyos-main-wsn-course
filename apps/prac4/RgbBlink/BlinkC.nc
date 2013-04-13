/**
 * Implementation for Blink application.  Toggle the red LED when a
 * Timer fires.
 **/

#include "Timer.h"

module BlinkC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface RgbLed;
  uses interface Leds;
  uses interface Boot;
}
implementation
{

  uint8_t counter = 0;

  event void Boot.booted()
  {
    call RgbLed.setColorRgb(128, 0, 0);
    call Leds.set(0);
    
    call Timer0.startPeriodic(250);
  }

  event void Timer0.fired()
  {
  
    uint8_t phase = counter % 3;
    
    if (phase == 0) call RgbLed.setColorRgb(128, 0, 0);
    else if (phase == 1) call RgbLed.setColorRgb(0, 128, 0);
    else if (phase == 2) call RgbLed.setColorRgb(0, 0, 128);

    call Leds.set((counter & 0x7));
    
    counter++;
  }
  
}

