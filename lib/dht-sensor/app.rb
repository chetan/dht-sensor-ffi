
module DhtSensor
  class App

    DEFAULT_OPTIONS = {
      :command => :read,
      :pin     => 4,
      :type    => 22,
      :unit    => :c
    }

    def run!

      if ARGV.empty? then
        @options = DEFAULT_OPTIONS.dup
        do_read()
        return
      end

      require "optparse"
      require "optparse/time"

      @options = parse_opts()
      validate_opts(@options)

      case @options[:command]
      when :read
        do_read()
      when :json
        do_json()
      when :loop
        do_loop()
      end
    end



    private

    def do_read
      print(read())
      exit
    end

    def do_loop
      while true do
        print(read())
        sleep 2
      end
    end

    def do_json
      require "json"
      puts JSON.dump(to_hash(read()))
    end

    # Convert to sensor reading to hash
    def to_hash(val)
      if @options[:humidity] then
        return {"humidity" => val.humidity}
      end

      if @options[:unit] == :c then
        if @options[:temperature] then
          return {"temperature" => val.temp}
        else
          return {"temperature" => val.temp, "humidity" => val.humidity}
        end
      else
        if @options[:temperature] then
          return {"temperature" => val.temp_f}
        else
          return {"temperature" => val.temp_f, "humidity" => val.humidity}
        end
      end
    end

    # Print to stdout, taking the various output options into account
    def print(val)
      if @options[:humidity] then
        puts sprintf("Humidity: %.2f%%", val.humidity)
        return
      end

      if @options[:unit] == :c then
        if @options[:temperature] then
          puts sprintf("Temperature: %.2f C", val.temp)
        else
          puts sprintf("Temperature: %.2f C Humidity: %.2f%%", val.temp, val.humidity)
        end
      else
        if @options[:temperature] then
          puts sprintf("Temperature: %.2f F", val.temp_f, val.humidity)
        else
          puts sprintf("Temperature: %.2f F Humidity: %.2f%%", val.temp_f, val.humidity)
        end
      end
    end

    def read
      DhtSensor.read(@options[:pin], @options[:type])
    end

    def validate_opts(opts)

      if opts[:type] && ![11, 22].include?(opts[:type]) then
        puts "error: invalid sensor type '#{opts[:type]}'; must be either 11 or 22"
        puts
        puts @opt_parser
        exit 1
      end

    end

    def parse_opts
      options = DEFAULT_OPTIONS.dup

      @opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: dht_sensor [command]"
        opts.separator ""
        opts.separator "Options:"

        opts.on("-r", "--read", "Read the current sensor values and print to STDOUT (default)") { options[:command] = :read }
        opts.on("-j", "--json", "Read the current sensor values and output as JSON") { options[:command] = :json }
        opts.on("-l", "--loop", "Continuously read from the sensor and print to STDOUT") { options[:command] = :loop }
        opts.on("-t", "--temp", "Temperature only") { options[:temp] = true }
        opts.on("-h", "--humidity", "Humidity only") { options[:humidity] = true }

        opts.on("-c", "--celsius", "Display temperature in Celsius (default)") { options[:unit] = :c }
        opts.on("-f", "--fahrenheit", "Display temperature in Fahrenheit") { options[:unit] = :f }

        opts.on("-p", "--pin PIN", "Pin number which sensor is connected to (default: 4)") { |t| options[:pin] = t.to_i }
        opts.on("-T", "--type TYPE",  "DHT sensor type, either 11 or 22 (default: 22)") { |t| options[:type] = t.to_i }

        opts.on_tail("--help", "Show this message") do
          puts opts
          exit
        end
      end

      @opt_parser.parse!(ARGV)
      options
    end

  end
end

DhtSensor::App.new.run!
