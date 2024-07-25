# @summary Configuration for the `zram` module
#
# @param ensure Set to `absent` to remove the configuration
# @param file_ensure Set to `absent` to remove the configuration files
#
class zram::config (
  Enum[
    'present',
    'absent'
  ] $ensure     = $zram::ensure,
  Enum[
    'file',
    'absent'
  ] $file_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }
) {
  assert_private()

  file { '/lib/udev/zram':
    ensure  => $file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => file('zram/zram.sh'),
  }

  file { '/etc/udev/rules.d/01-zram.rules':
    ensure  => $file_ensure,
    content => epp('zram/01-zram.rules.epp'),
  }

  kmod::option { 'zram':
    ensure => $ensure,
    option => 'num_devices',
    value  => $zram::numdevices,
  }
}
