# @summary Class fluentd install, configures and manages the fluentd (td-agent)
# service.
#
# @param repo_manage [Boolean] Whether to manage the repository or not.
# @param repo_name [String] The name of the repository.
# @param repo_desc [String] The description of the repository.
# @param repo_version [String] The version of the repository.
# @param repo_url [Optional[Stdlib::Httpurl]] The URL of the repository.
# @param repo_enabled [Boolean] Whether the repository is enabled or not.
# @param repo_gpgcheck [Boolean] Whether the repository has GPG check or not.
# @param repo_gpgkey [Stdlib::Httpurl] The URL of the GPG key.
# @param repo_gpgkeyid [String] The ID of the GPG key.
# @param package_name [String] The name of the package.
# @param package_ensure [String] The ensure value of the package.
# @param package_provider [Optional[String]] The provider of the package.
# @param service_name [String] The name of the service.
# @param service_ensure [String] The ensure value of the service.
# @param service_enable [Boolean] Whether the service is enabled or not.
# @param service_manage [Boolean] Whether to manage the service or not.
# @param config_file [Stdlib::Absolutepath] The path to the configuration file.
# @param config_file_mode [Optional[Stdlib::Filemode]] The mode of the configuration file.
# @param config_path [Stdlib::Absolutepath] The path to the configuration directory.
# @param config_path_mode [Optional[Stdlib::Filemode]] The mode of the configuration directory.
# @param config_owner [String] The owner of the configuration file and directory.
# @param config_group [String] The group of the configuration file and directory.
# @param configs [Hash] The hash of the configuration files.
# @param plugins [Hash] The hash of the plugins.
# @param purge_config_dir [Boolean] Whether to purge the configuration directory or not.
#
class fluentd (
  Boolean                     $repo_manage       = $fluentd::params::repo_manage,
  String                      $repo_name         = $fluentd::params::repo_name,
  String                      $repo_desc         = $fluentd::params::repo_desc,
  String                      $repo_version      = $fluentd::params::repo_version,
  Optional[Stdlib::Httpurl]   $repo_url          = undef,
  Boolean                     $repo_enabled      = $fluentd::params::repo_enabled,
  Boolean                     $repo_gpgcheck     = $fluentd::params::repo_gpgcheck,
  Stdlib::Httpurl             $repo_gpgkey       = $fluentd::params::repo_gpgkey,
  String                      $repo_gpgkeyid     = $fluentd::params::repo_gpgkeyid,
  String                      $package_name      = $fluentd::params::package_name,
  String                      $package_ensure    = $fluentd::params::package_ensure,
  Optional[String]            $package_provider  = $fluentd::params::package_provider,
  String                      $service_name      = $fluentd::params::service_name,
  String                      $service_ensure    = $fluentd::params::service_ensure,
  Boolean                     $service_enable    = $fluentd::params::service_enable,
  Boolean                     $service_manage    = $fluentd::params::service_manage,
  Stdlib::Absolutepath        $config_file       = $fluentd::params::config_file,
  Optional[Stdlib::Filemode]  $config_file_mode  = $fluentd::params::config_file_mode,
  Stdlib::Absolutepath        $config_path       = $fluentd::params::config_path,
  Optional[Stdlib::Filemode]  $config_path_mode  = $fluentd::params::config_path_mode,
  String                      $config_owner      = $fluentd::params::config_owner,
  String                      $config_group      = $fluentd::params::config_group,
  Hash                        $configs           = $fluentd::params::configs,
  Hash                        $plugins           = $fluentd::params::plugins,
  Boolean                     $purge_config_dir  = $fluentd::params::purge_config_dir
) inherits fluentd::params {
  contain fluentd::install
  contain fluentd::service

  Class['fluentd::install'] -> Class['fluentd::service']

  create_resources('fluentd::plugin', $plugins)
  create_resources('fluentd::config', $configs)
}
