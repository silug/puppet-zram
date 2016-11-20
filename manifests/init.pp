# Class: zram
# ===========================
#
# Full description of class zram here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'zram':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
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
