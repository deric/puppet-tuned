# @summary Manage tuneD service
#
# @api private
class tuned::service {
  service { $tuned::service_name:
    ensure => $tuned::service_ensure,
    enable => true,
  }
}
