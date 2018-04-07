# zram::load
#
# Loads the zram kernel module.  Intended
# to be called from the main zram class.
#
# @summary Loads the zram kernel module
#
# @example
#   include zram::load
class zram::load {
  assert_private()

  kmod::load { 'zram': }
}
