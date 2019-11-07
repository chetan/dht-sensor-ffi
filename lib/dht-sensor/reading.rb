
module DhtSensor
  class Reading

    attr_reader :temperature, :humidity

    def initialize(temp, hum)
      @temperature = temp
      @humidity    = hum
    end

    def temperature_f
      (@temperature * 9/5) + 32
    end
    alias_method :temp_f, :temperature_f
    alias_method :temp, :temperature

  end
end
