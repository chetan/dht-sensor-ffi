
require "dht-sensor/dht_sensor" # load ext
require "dht-sensor/reading"

require "ffi"

module DhtSensor
  extend FFI::Library

  ffi_lib File.expand_path("../dht-sensor/dht_sensor.so", __FILE__)

  attach_function :readDHT, [:int, :int, :pointer, :pointer], :long

  def self.read(pin, type=22, tries=50)

    temperature = FFI::MemoryPointer.new(:float)
    humidity = FFI::MemoryPointer.new(:float)

    ret = nil
    1.upto(tries) do
      ret = DhtSensor.readDHT(type, pin, temperature, humidity)
      break if ret == 0 && !(temperature.read_float == 0.0 && humidity.read_float == 0.0)
      sleep 0.1
    end

    if ret != 0 then
      raise "Failed to read from sensor (read call returned #{ret})"
    end

    Reading.new(temperature.read_float, humidity.read_float)
  end
end
