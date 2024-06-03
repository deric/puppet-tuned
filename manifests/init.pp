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
# @example
#   include tuned
class tuned (
  Boolean $enable,
  Boolean $manage_package,
  Boolean $manage_service,
  String  $package_ensure,
  String  $service_ensure,
  String  $service_name,
  Array[String[1]] $packages,
) {
  if $manage_package {
    ensure_packages($tuned::packages, {
        ensure => $package_ensure,
    })
  }

  if $enable {
    include tuned::config
  }

  if $tuned::manage_service {
    include tuned::service
  }
}
