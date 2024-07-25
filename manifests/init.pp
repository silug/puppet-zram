# zram
#
# This module configures zram using udev rules (no init scripts or systemd
# units needed).
#
# @summary Configures and loads zram kernel module
#
# @param numdevices Number of zram devices.  Defaults to the number of processors (`$facts['processorcount']`).
# @param disksize Size of zram devices.  Defaults to half of memory divided by `numdevices`.
# @param ensure Set to `absent` to remove zram.
# @param swapoff
#   When `ensure` is `absent`, attempt to disable zram swap before
#   unloading the kernel module. Without this set, you will need to
#   proactively run `swapoff` on each `/dev/zram*` device or reboot
#   following a failed unload attempt.
# @param swapoff_timeout
#   Timeout for the `swapoff` command. (See the
#   [`exec` `timeout` attribute documentation](https://www.puppet.com/docs/puppet/latest/types/exec.html#exec-attribute-timeout)
#   for details.)
#
# @example
#    include zram
#
# @author Steven Pritchard <steven.pritchard@gmail.com>
#
class zram (
  Integer              $numdevices      = $facts['processors']['count'],
  Integer              $disksize        = (($facts['memory']['system']['total_bytes'] / 2) / $numdevices),
  Enum[
    'present',
    'absent'
  ]                    $ensure          = 'present',
  Boolean              $swapoff         = false,
  Optional[Integer[0]] $swapoff_timeout = undef,
) {
  contain zram::install
  contain zram::config
  contain zram::load

  Class['zram::install']
  -> Class['zram::config']
  -> Class['zram::load']
}
