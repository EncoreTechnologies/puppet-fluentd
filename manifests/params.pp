# `fluentd::params` is a Puppet class that sets common parameters for the Fluentd module.
# It sets default values for a number of variables, including the repository name and version, 
# the package name, the owner and group of the package, the service name, and the configuration file name.
# It also sets different values for these variables based on the version of the repository and the operating system.
class fluentd::params inherits fluentd::globals {
  $repo_name = 'treasuredata'
  $repo_desc = 'TreasureData'
  $repo_version = $fluentd::globals::repo_version

  $package_name = $fluentd::globals::package_name
  $package_path = $fluentd::globals::package_path
  $owner_group_name = $fluentd::globals::owner_group_name
  $service_name = $fluentd::globals::service_name
  $config_file_name = $fluentd::globals::config_file_name

  case $facts['os']['family'] {
    'RedHat', 'Debian': {
      $manage_user_group = true
      $parent_path = "/etc/${package_path}"
      $config_file = "/etc/${package_path}/${service_name}.conf"
      $config_file_mode = '0640'
      $config_path = "/etc/${package_path}/config.d"
      $config_path_mode = '0750'
      $config_owner = $owner_group_name
      $config_group = $owner_group_name
      $package_provider = undef
      $repo_manage = true
    }
    'windows': {
      $manage_user_group = false
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
