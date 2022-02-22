# zram::load
#
# Loads the zram kernel module.  Intended
# to be called from the main `zram` class.
#
# @summary Loads the zram kernel module
#
# @example
#   include zram::load
class zram::load {
  assert_private()

  if $facts['os']['name'] == 'Ubuntu' {
    # The zram module is in linux-modules-extra on Ubuntu.
    package { "linux-modules-extra-${facts['kernelrelease']}":
      ensure => installed,
      before => Kmod::Load['zram'],
    }
  }

  kmod::load { 'zram': }
}
