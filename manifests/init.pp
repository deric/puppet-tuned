# @summary Manage tuned configs and profiles
#
# @param enable
#   Whether OS tuning is enabled
# @param manage_package
#   Whether package should be managed.
# @param manage_service
#   Whether service should be managed.
# @param package_ensure
#   Either specific version or `installed` | `present` | `latest`
# @param service_ensure
# @param service_name Name of the service
# @param packages
#   Packages to be installed by this module.
# @param main_config
#   Path to the tuned-main.conf file
# @param main
#   Key-value configs to override tuned-main.conf
# @param profile
#   Currently active profile, if not set will be selected automatically.
#   Use `tuned-adm list` to see available profiles
# @param profiles_path
#   Path to profiles directory
# @param profiles
#   Hash containing definition of custom profiles
# @example
#   include tuned
class tuned (
  Boolean              $enable,
  Boolean              $manage_package,
  Boolean              $manage_service,
  String               $package_ensure,
  String               $service_ensure,
  String               $service_name,
  Array[String[1]]     $packages,
  Stdlib::AbsolutePath $main_config,
  Tuned::Config        $main = {},
  Optional[String]     $profile = undef,
  Stdlib::AbsolutePath $profiles_path,
  Hash                 $profiles = {},
) {
  include tuned::install

  if $enable {
    include tuned::config

    if ! empty($tuned::profile) {
      Ini_setting {
        before => Exec['tuned-adm_profile'],
      }
    }

    exec { 'tuned-adm_profile':
      command => shellquote('tuned-adm', 'profile', $tuned::profile),
      unless  => shellquote('tuned-adm', 'active | grep -q', $tuned::profile),
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      require => Class['Tuned::Config'],
    }

    Class['tuned::install']
    -> Class['tuned::config']

    $profiles.each |$name, $conf| {
      create_resources(tuned::profile, { $name => $conf })
    }
  }

  if $tuned::manage_service {
    include tuned::service
  }
}
