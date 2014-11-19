
require "dht-sensor/reading"

require "ffi"

module DhtSensor
  extend FFI::Library

  ffi_lib File.expand_path("../dht-sensor-ffi/dht_sensor.so", __FILE__)

  attach_function :readDHT, [:int, :int, :pointer, :pointer], :long

  def self.read

    temperature = FFI::MemoryPointer.new(:float)
    humidity = FFI::MemoryPointer.new(:float)

    tries = 3
    while tries > 0 do
      tries -= 1
      ret = DhtSensor.readDHT(22, 4, temperature, humidity)
      break if ret == 0
      sleep 0.5
    end

    return Reading.new(temperature.read_float, humidity.read_float)
  end
end
