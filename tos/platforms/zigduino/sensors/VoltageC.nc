

generic configuration VoltageC() {
  provides interface Read<uint16_t>;
}
implementation {

  components new AtmegaVoltageC();
  Read = AtmegaVoltageC;
}
