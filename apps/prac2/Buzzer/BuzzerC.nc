
/**
 * 
 * Button demo application.
 *
 * @author Philipp Sommer
 */

#include "Timer.h"

module BuzzerC
{
  uses {
    interface Boot;
    interface Leds;
    interface GeneralIO as Buzzer;
    interface GeneralIO as Button;
    interface GpioInterrupt;
    interface Timer<TMilli>;
  }
}

implementation
{

  static bool buzzer_on = TRUE;
 
  event void Boot.booted() {

    call Button.makeInput();
    call GpioInterrupt.enableFallingEdge(); 
    
    call Buzzer.makeOutput();
    call Buzzer.clr();

    call Leds.led0Off();
    call Leds.led1Off();
    call Leds.led2Off();

    call Timer.startPeriodic(250);
  }


  event void Timer.fired() 
  {

    // Beep Buzzer
    if(buzzer_on){

        call Leds.led0Toggle();
        call Leds.led1Toggle();
        call Leds.led2Toggle();
        
        call Buzzer.toggle();

    } else {

        call Leds.led0Off();
        call Leds.led1Off();
        call Leds.led2Off();

        call Buzzer.clr();
    }
    
    // Re enable interrupt
    call GpioInterrupt.enableFallingEdge(); 
  }
 
 
  async event void GpioInterrupt.fired() {

    // Enable Buzzer
    buzzer_on = !buzzer_on;

    // Disable interrupt temporarily to prevent bouncing
    call GpioInterrupt.disable(); 
  }

}

