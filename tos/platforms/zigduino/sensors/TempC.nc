

generic configuration TempC() {
  provides interface Read<int16_t>;
}
implementation {

  components new AtmegaTemperatureC();
  Read = AtmegaTemperatureC;
}
