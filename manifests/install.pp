# @summary Install required packages
#
# @api private
class tuned::install {
  if $tuned::manage_package {
    stdlib::ensure_packages($tuned::packages, {
        ensure => $tuned::package_ensure,
    })

    if $tuned::manage_dependencies and !empty($tuned::dependencies) {
      stdlib::ensure_packages($tuned::dependencies, {
          ensure => $tuned::package_ensure,
      })
    }
  }
}
