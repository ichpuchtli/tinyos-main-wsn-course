

generic configuration LightSensorC() {
  provides interface Read<uint16_t>;
}
implementation {
  components new AdcReadClientC(), ZigduinoAnalogPortsC;

  Read = AdcReadClientC;
  AdcReadClientC.Atm128AdcConfig -> ZigduinoAnalogPortsC.Analog0;
}
