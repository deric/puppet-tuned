# @summary A tuneD profile
#
# Manages profile config
#
# @example
#   tuned::profile { 'high-performance': }
define tuned::profile (
  Pattern[/^[\w\-]+$/]                    $profile_name  = $title,
  Enum['present', 'absent']               $ensure        = present,
  Tuned::Config                           $config          = {},
  Stdlib::Absolutepath                    $profiles_path = $tuned::profiles_path
) {
  $profile_dir = "${profiles_path}/${profile_name}"

  case $ensure {
    present: {
      file { $profile_dir:
        ensure  => directory,
        require => Class['tuned::install'],
      }

      file { "${profile_dir}/tuned.conf":
        ensure  => file,
        content => epp("${module_name}/profile.epp", { 'config' => $config }),
        before  => Class['tuned::config'],
      }
    }

    absent: {
      file { $profile_dir:
        ensure  => absent,
        recurse => true,
        force   => true,
      }
    }

    default: {
      fail("Unsupported ensure state ${ensure}")
    }
  }
}
