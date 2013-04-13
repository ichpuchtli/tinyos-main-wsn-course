#include "Timer.h"
#include "printf.h"

module SenseC
{
  uses
  {
    interface Boot;
    interface Leds;
    interface Timer < TMilli >;
    interface Read < uint16_t > as LightSensor;
    interface Read < int16_t > as TempSensor;
    interface StdControl as SerialControl;
    interface UartStream;
  }
}

implementation
{

  int16_t TempSensorValue = 0;
  uint16_t LightSensorValue = 0;

  task void json_printer_task ();


  event void Boot.booted ()
  {
    // Initialize Serial Control
    call SerialControl.start ();
    // Start Periodic Timer
    call Timer.startPeriodic (200);
  }

  event void Timer.fired ()
  {
    // Trigger ADC Conversion
    call TempSensor.read ();
    // Trigger ADC Conversion
    call LightSensor.read ();

    // Schedule a task to print the sensor values sometime in the future 
    post json_printer_task ();
  }

  event void TempSensor.readDone (error_t result, int16_t data)
  {
    if (result == SUCCESS)
      TempSensorValue = data;
  }


  event void LightSensor.readDone (error_t result, uint16_t data)
  {
    if (result == SUCCESS)
      LightSensorValue = data;
  }

  task void json_printer_task ()
  {

    // Print the sensor readings in JSON format
    printf ("{\"id\": %u, \"temp\": %d, \"light\": %u}\r\n", TOS_NODE_ID,
	    TempSensorValue, LightSensorValue);

    printfflush ();
  }

  /**
   * Signals the receipt of a byte.
   * @param byte The byte received.
   */
  async event void UartStream.receivedByte (uint8_t byte)
  {
    // not implemented
  }

  /**
   * Signal completion of receiving a stream.
   * @param uint8_t* COUNT(len) buf Buffer for bytes received.
   * @param len Number of bytes received.
   * @param error SUCCESS if the reception was successful, FAIL otherwise.
   */
  async event void UartStream.receiveDone (uint8_t * buf, uint16_t len,
					   error_t error)
  {
    // not implemented
  }


  /**
   * Signal completion of sending a stream.
   * @param uint8_t* COUNT(len) buf Bytes sent.
   * @param len Number of bytes sent.
   * @param error SUCCESS if the transmission was successful, FAIL otherwise.
   */
  async event void UartStream.sendDone (uint8_t * buf, uint16_t len,
					error_t error)
  {
    // not implemented
  }
}
