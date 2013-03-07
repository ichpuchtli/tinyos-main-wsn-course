/*
 * Copyright (c) 2012 Sapienza University of Rome.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Sapienza University of Rome nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SAPIENZA
 * UNIVERSITY OF ROME OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Author: Ugo Colesanti <colesanti@dis.uniroma1.it>
 * Philipp Sommer <philipp.sommer@csiro.au>
 */

module ZigduinoAnalogPortsP{
  provides {
    interface Init;
    interface Atm128AdcConfig as Atm128AdcConfig0;
    interface Atm128AdcConfig as Atm128AdcConfig1;
    interface Atm128AdcConfig as Atm128AdcConfig2;
    interface Atm128AdcConfig as Atm128AdcConfig3;
    interface Atm128AdcConfig as Atm128AdcConfig4;
    interface Atm128AdcConfig as Atm128AdcConfig5;

  }
}
implementation {

  command error_t Init.init() {
    atomic {
      dbg("Init", "ZigduinoAnalogPorts: initialized.\n");
      DDRF &= ~0x3f ; PORTF |= 0x3f;
    }
    return SUCCESS;
  }

  
  /********* ADC Channel 0 *********/
  async command uint8_t Atm128AdcConfig0.getChannel()
  {
    return ATM128_ADC_SNGL_ADC0;
  }

  async command uint8_t Atm128AdcConfig0.getRefVoltage()
  {
    return ATM128_ADC_VREF_OFF; // external AREF to be connected to 3.3V
  }

  async command uint8_t Atm128AdcConfig0.getPrescaler()
  {
    return ATM128_ADC_PRESCALE;
  }

  /********* ADC Channel 1 *********/
  async command uint8_t Atm128AdcConfig1.getChannel()
  {
    return ATM128_ADC_SNGL_ADC1;
  }

  async command uint8_t Atm128AdcConfig1.getRefVoltage()
  {
    return ATM128_ADC_VREF_OFF; // external AREF to be connected to 3.3V
  }

  async command uint8_t Atm128AdcConfig1.getPrescaler()
  {
    return ATM128_ADC_PRESCALE;
  }

  /********* ADC Channel 2 *********/
  async command uint8_t Atm128AdcConfig2.getChannel()
  {
    return ATM128_ADC_SNGL_ADC2;
  }

  async command uint8_t Atm128AdcConfig2.getRefVoltage()
  {
    return ATM128_ADC_VREF_OFF; // external AREF to be connected to 3.3V
  }

  async command uint8_t Atm128AdcConfig2.getPrescaler()
  {
    return ATM128_ADC_PRESCALE;
  }

  /********* ADC Channel 3 *********/
  async command uint8_t Atm128AdcConfig3.getChannel()
  {
    return ATM128_ADC_SNGL_ADC3;
  }

  async command uint8_t Atm128AdcConfig3.getRefVoltage()
  {
    return ATM128_ADC_VREF_OFF; // external AREF to be connected to 3.3V
  }

  async command uint8_t Atm128AdcConfig3.getPrescaler()
  {
    return ATM128_ADC_PRESCALE;
  }

  /********* ADC Channel 4 *********/
  async command uint8_t Atm128AdcConfig4.getChannel()
  {
    return ATM128_ADC_SNGL_ADC4;
  }

  async command uint8_t Atm128AdcConfig4.getRefVoltage()
  {
    return ATM128_ADC_VREF_OFF; // external AREF to be connected to 3.3V
  }

  async command uint8_t Atm128AdcConfig4.getPrescaler()
  {
    return ATM128_ADC_PRESCALE;
  }

  /********* ADC Channel 5 *********/
  async command uint8_t Atm128AdcConfig5.getChannel()
  {
    return ATM128_ADC_SNGL_ADC5;
  }

  async command uint8_t Atm128AdcConfig5.getRefVoltage()
  {
    return ATM128_ADC_VREF_OFF; // external AREF to be connected to 3.3V
  }

  async command uint8_t Atm128AdcConfig5.getPrescaler()
  {
    return ATM128_ADC_PRESCALE;
  }


}
