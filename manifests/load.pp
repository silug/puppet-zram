# @summary Loads the zram kernel module
#
# @param ensure Set to `absent` to unload the kernel module
# @param swapoff
#   When `ensure` is `absent`, attempt to disable zram swap before
#   unloading the kernel module
# @param swapoff_timeout Timeout for the `swapoff` command
#
class zram::load (
  Enum[
    'present',
    'absent'
  ]                    $ensure          = $zram::ensure,
  Boolean              $swapoff         = $zram::swapoff,
  Optional[Integer[0]] $swapoff_timeout = $zram::swapoff_timeout,
) {
  assert_private()

  if $ensure == 'absent' and $swapoff {
    exec { 'Disable zram swap':
      command => "awk '/^\\/dev\\/zram[0-9]/{print \$1}' /proc/swaps | xargs -n 1 swapoff",
      onlyif  => 'grep -q "^/dev/zram[0-9]" /proc/swaps',
      path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
      timeout => $swapoff_timeout,
      before  => Kmod::Load['zram'],
    }
  }

  kmod::load { 'zram':
    ensure => $ensure,
  }
}
