generic module ZigduinoSingleAdcConfigC(uint8_t channel, uint8_t vref) {
  provides interface Atm128AdcConfig;
}

implementation {

  async command uint8_t Atm128AdcConfig.getChannel()
  {
    return channel;
  }

  async command uint8_t Atm128AdcConfig.getRefVoltage()
  {
    return vref;
  }

  async command uint8_t Atm128AdcConfig.getPrescaler()
  {
    return ATM128_ADC_PRESCALE;
  }
  
}

