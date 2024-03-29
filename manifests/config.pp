# @summary Configuration for the `zram` module
#
class zram::config {
  assert_private()

  file { '/lib/udev/zram':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => file('zram/zram.sh'),
  }

  file { '/etc/udev/rules.d/01-zram.rules':
    ensure  => file,
    content => epp('zram/01-zram.rules.epp'),
  }

  kmod::option { 'zram':
    option => 'num_devices',
    value  => $zram::numdevices,
  }
}
