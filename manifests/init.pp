# Class: zram
# ===========================
#
# This module configures zram using udev rules (no init scripts or systemd units
# needed).
#
# Parameters
# ----------
#
# * `numdevices`
# Number of zram devices.  Defaults to the number of processors
# ($::processorcount).
#
# * `disksize`
# Size of zram devices.  Defaults to half of memory divided by numdevices.
#
# Examples
# --------
#
#    class { 'zram': }
#
# Authors
# -------
#
# Steven Pritchard <steven.pritchard@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2016 Steven Pritchard
#
class zram (
  $numdevices=$::processorcount,
  $disksize=(floor(($::memorysize_mb/2)*1048576/$numdevices))) {
  file { '/lib/udev/zram':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/zram/zram.sh',
  } ->
  file { '/etc/udev/rules.d/01-zram.rules':
    ensure  => file,
    content => template('zram/01-zram.rules.erb'),
  } ->
  kmod::option { 'zram':
    option => 'num_devices',
    value  => $numdevices,
  } ->
  kmod::load { 'zram': }
}
