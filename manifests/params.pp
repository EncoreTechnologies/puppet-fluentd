# Common fluentd parameters
class fluentd::params {
  $repo_name = 'treasuredata'
  $repo_desc = 'TreasureData'
  $repo_version = '4'

  case $facts['os']['family'] {
    'RedHat': {
      if $repo_version == 0 {
        $package_name = 'td-agent'
        $package_path = 'td-agent'
      }
      else {
        $package_name = 'fluentd'
        $package_path = 'fluent'
      }

      if (versioncmp($facts['os']['release']['major'], '8') <= 0) {
        $config_file = "/etc/${package_path}/${package_name}.conf"
        $config_file_mode = '0640'
        $config_path = "/etc/${package_path}/config.d"
        $config_path_mode = '0750'
        $config_owner = $package_name
        $config_group = $package_name
        $package_provider = undef
        $repo_manage = true
        $service_name = $package_name
      }
      else {
        $config_file = "/etc/${package_path}/fluentd.conf"
        $config_file_mode = '0640'
        $config_path = "/etc/${package_path}/config.d"
        $config_path_mode = '0750'
        $config_owner = $package_name
        $config_group = $package_name
        $package_provider = undef
        $repo_manage = true
        $service_name = $package_name
      }
    }
    'Debian': {
      $config_file = '/etc/td-agent/td-agent.conf'
      $config_file_mode = '0640'
      $config_path = '/etc/td-agent/config.d'
      $config_path_mode = '0750'
      $config_owner = 'td-agent'
      $config_group = 'td-agent'
      $package_provider = undef
      $repo_manage = true
      $service_name = 'td-agent'
    }
    'windows': {
      $config_file = 'C:/opt/td-agent/etc/td-agent/td-agent.conf'
      $config_file_mode = undef
      $config_path = 'C:/opt/td-agent/etc/td-agent/config.d'
      $config_path_mode = undef
      $config_owner = 'Administrator'
      $config_group = 'Administrator'
      $package_provider = 'chocolatey'
      # there is no public repo for windows, we assume that the user has already
      # setup the Chocolatey sources correctly
      $repo_manage = false
      # windows service uses a different name
      $service_name = 'fluentdwinsvc'
    }
    default: {
      fail("Unsupported osfamily ${facts['os']['family']}")
    }
  }

  $repo_enabled = true
  $repo_gpgcheck = true
  $repo_gpgkey = 'https://packages.treasuredata.com/GPG-KEY-td-agent'
  $repo_gpgkeyid = 'BEE682289B2217F45AF4CC3F901F9177AB97ACBE'

  $package_ensure = present

  $service_ensure = running
  $service_enable = true
  $service_manage = true

  $configs = {}

  $plugins = {}

  $purge_config_dir = false
}
