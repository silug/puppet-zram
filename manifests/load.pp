# @summary Loads the zram kernel module
#
class zram::load {
  assert_private()

  kmod::load { 'zram': }
}
