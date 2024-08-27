# @summary Ensures tuned config files are up-to-date
#
# @api private
class tuned::config (
  Tuned::Main $main = $tuned::main,
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
          setting => $option,
          value   => $value,
      }
    }
  }

  $tuned::profiles.each |$name, $conf| {
    create_resources(tuned::profile, { $name => { 'config' => $conf } })
  }
}
