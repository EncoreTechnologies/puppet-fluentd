# Resource for managing the FluentD service
class fluentd::service {
  include fluentd
  if $fluentd::service_manage {
    # Determine the service name based on the OS family and Fluentd version
    $_service_name = $facts['os']['family'] ? {
      'windows' => $fluentd::service_name_windows,
      default   => $fluentd::service_name,
    }

    service { $_service_name:
      ensure => $fluentd::service_ensure,
      enable => $fluentd::service_enable,
    }
  }
}
