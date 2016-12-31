# DHT Sensor FFI

A Ruby library for reading from a DHT-11 or DHT-22 type sensor connected to a Raspberry Pi
 
## Installation

First install the bcm2835 lib, available at:
http://www.airspayce.com/mikem/bcm2835

Then either install manually

```
gem install dht-sensor-ffi
```

or add to your Gemfile

```
gem "dht-sensor-ffi"
```

## Usage

```ruby
require "dht-sensor-ffi"
val = DhtSensor.read(4, 22) # pin=4, sensor type=DHT-22
puts val.temp               # => 21.899999618530273 (temp in C)
puts val.temp_f             # => 71.4199993133545 (temp in F)
puts val.humidity           # => 22.700000762939453 (relative humidity %)
```

There is also a simple binary for testing purposes

```bash
$ dht_sensor
Temperature: 22.40 C Humidity: 26.70%
```

## Contributing to dht-sensor-ffi

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Chetan Sarva. Licensed under the MIT license. See LICENSE.txt for further details.
