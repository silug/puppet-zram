# zram
#
# This module configures zram using udev rules (no init scripts or systemd
# units needed).
#
# @summary Configures and loads zram kernel module
#
# @param numdevices Number of zram devices.  Defaults to the number of processors (`$facts['processorcount']`).
#
# @param disksize Size of zram devices.  Defaults to half of memory divided by `numdevices`.
#
# @example
#    class { 'zram': }
#
# @author Steven Pritchard <steven.pritchard@gmail.com>
#
class zram (
  Integer $numdevices = $facts['processorcount'],
  Integer $disksize   = (floor(($facts['memorysize_mb']/2)*1048576/$numdevices)),
) {
  contain zram::config
  contain zram::load

  Class['zram::config'] -> Class['zram::load']
}
