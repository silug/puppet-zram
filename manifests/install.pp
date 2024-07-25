# @summary Add or remove packages to enable zram management
#
# @param required Packages required for zram to function
# @param conflicts Packages that conflict with zram
# @param required_ensure `ensure` attribute of `required` packages
# @param conflicts_ensure `ensure` attribute of `conflicts` packages
# @param ensure Set to `absent` to skip package operations
#
class zram::install (
  Variant[
    Undef,
    String[1],
    Array[String[1]]
  ]                  $required         = undef,
  Variant[
    Undef,
    String[1],
    Array[String[1]]
  ]                  $conflicts        = undef,
  String[1]          $required_ensure  = 'installed',
  String[1]          $conflicts_ensure = 'absent',
  Enum[
    'present',
    'absent'
  ]                  $ensure           = $zram::ensure,
) {
  assert_private()

  if $ensure == 'present' {
    if $required {
      package { $required:
        ensure => $required_ensure,
      }
    }

    if $conflicts {
      package { $conflicts:
        ensure => $conflicts_ensure,
      }
    }
  }
}
