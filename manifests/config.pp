# @summary Ensures tuned config files are up-to-date
#
# @api private
class tuned::config (
  Tuned::Config $main = $tuned::main,
) {
  if ! empty($tuned::main_config) {
    if $tuned::manage_service {
      Ini_setting {
        path    => $tuned::main_config,
        notify  => Service[$tuned::service_name],
      }
    }

    $main.each |String $option, $value| {
      ini_setting {
        "tuned-${option}":
          path    => $tuned::main_config,
          setting => $option,
          value   => $value,
      }
    }
  }
}
