# @summary A tuneD profile
#
# Manages profile config
#
# @param profile_name Name of the profile
# @param ensure
# @param config multi-level ini config with sections
# @param profiles_path Path to profiles
#
# @example
#   tuned::profile { 'high-performance': }
define tuned::profile (
  Pattern[/^[\w\-]+$/]                    $profile_name  = $title,
  Enum['present', 'absent']               $ensure        = present,
  Tuned::Config                           $config        = {},
  Stdlib::Absolutepath                    $profiles_path = $tuned::profiles_path
) {
  $profile_dir = "${profiles_path}/${profile_name}"

  case $ensure {
    'present': {
      file { $profile_dir:
        ensure  => directory,
        require => Class['tuned::install'],
      }

      $config_path = "${profile_dir}/tuned.conf"

      Ini_setting {
        path    => $config_path,
        notify  => Service[$tuned::service_name],
      }

      $config.each |String $section, $hash| {
        $hash.each |String $setting, $value| {
          ini_setting {
            "tuned-${title}-${section}-${setting}":
              section => $section,
              setting => $setting,
              value   => $value,
          }
        }
      }
    }

    'absent': {
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
