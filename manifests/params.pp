# Common fluentd parameters
class fluentd::params {
  $repo_name = 'treasuredata'
  $repo_desc = 'TreasureData'
  $repo_version = '4'

  case $repo_version {
    '4': {
      $package_name = 'td-agent'
      $package_path = 'td-agent'
      $owner_group_name = 'td-agent'
      $service_name = 'td-agent'
      $config_file_name = 'td-agent.conf'
    }
    '5': {
      $package_name = 'fluent-package'
      $owner_group_name = 'fluentd'
      $package_path = 'fluent'
      $service_name = 'fluentd'
      $config_file_name = 'fluentd.conf'
    }
    default: {
      fail("Unsupported repo_version ${repo_version}")
    }
  }

  case $facts['os']['family'] {
    'RedHat', 'Debian': {
      $parent_path = "/etc/${package_path}"
      $config_file = "/etc/${package_path}/${config_file_name}"
      $config_file_mode = '0640'
      $config_path = "/etc/${package_path}/config.d"
      $config_path_mode = '0750'
      $config_owner = $owner_group_name
      $config_group = $owner_group_name
      $package_provider = undef
      $repo_manage = true
    }
    'windows': {
      $parent_path = "C:/opt/${package_path}"
      $config_file = "C:/opt/${package_path}/etc/${package_path}/${config_file_name}"
      $config_file_mode = undef
      $config_path = "C:/opt/${package_path}/etc/${package_path}/config.d"
      $config_path_mode = undef
      $config_owner = 'Administrator'
      $config_group = 'Administrator'
      $package_provider = 'chocolatey'
      # there is no public repo for windows, we assume that the user has already
      # setup the Chocolatey sources correctly
      $repo_manage = false
      # windows service uses a different name
      $service_name_windows = 'fluentdwinsvc'
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
