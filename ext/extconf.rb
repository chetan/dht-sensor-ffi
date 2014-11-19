
require 'mkmf'

LIBDIR      = RbConfig::CONFIG['libdir']
INCLUDEDIR  = RbConfig::CONFIG['includedir']

HEADER_DIRS = [
  '/opt/local/include',
  '/usr/local/include',
  INCLUDEDIR,
  '/usr/include',
]

LIB_DIRS = [
  '/opt/local/lib',
  '/usr/local/lib',
  LIBDIR,
  '/usr/lib',
]

unless find_header('bcm2835.h')
  abort 'bcm2835 is missing, for production you will need to install http://www.airspayce.com/mikem/bcm2835/'
end

unless have_library('bcm2835') && append_library($libs, 'bcm2835')
  abort "Can't Appended Library bcm2835! for production you will need to install http://www.airspayce.com/mikem/bcm2835/"
end

dir_config('bcm2835', HEADER_DIRS, LIB_DIRS)

# $CFLAGS << ' -std=c99'

# Give it a name
#extension_name = 'dht_sensor'

# The destination
#dir_config(extension_name)

# Do the work
create_makefile("dht-sensor/dht_sensor")
