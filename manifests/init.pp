# @summary Manage tuned configs and profiles
#
# @param enable
#   Whether OS tuning is enabled
# @param manage_package
#   Whether tuned package should be managed.
# @param manage_service
#   Whether service should be managed.
# @param manage_dependencies
#   Whether extra dependencies (might be used by plugins) should be installed.
# @param package_ensure
#   Either specific version or `installed` | `present` | `latest`
# @param service_ensure
# @param service_name Name of the service
# @param active_profile
#   Name of the file containing curretly active profile (located in main config directory)
# @param packages
#   Packages to be installed by this module.
# @param dependencies
#   Extra packages required by plugins.
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
  Boolean              $manage_dependencies,
  String               $package_ensure,
  String               $service_ensure,
  String               $service_name,
  Array[String[1]]     $packages,
  String[1]            $active_profile,
  Stdlib::AbsolutePath $main_config,
  Stdlib::AbsolutePath $profiles_path,
  Array[String[1]]     $dependencies = [],
  Tuned::Main          $main = {},
  Optional[String]     $profile = undef,
  Hash                 $profiles = {},
) {
  include tuned::install

  if $enable {
    include tuned::config

    Class['tuned::install']
    -> Class['tuned::config']

    if !empty($tuned::profile) {
      Ini_setting {
        before => Exec['tuned-adm_profile'],
      }

      $active_profile_path = "${profiles_path}/${active_profile}"

      exec { 'tuned-adm_profile':
        command => shellquote('tuned-adm', 'profile', $tuned::profile),
        unless  => shellquote('grep', '-Fqx', $tuned::profile, $active_profile_path),
        path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        require => Class['Tuned::Config'],
      }
    }
  }

  if $tuned::manage_service {
    include tuned::service
  }
}
