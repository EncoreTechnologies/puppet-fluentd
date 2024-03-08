# `fluentd::init` is the main entry point for the Fluentd module.
# It includes the other classes in the module and manages the Fluentd service.
#
# @param repo_manage Whether to manage the Fluentd repository.
# @param repo_name The name of the repository.
# @param repo_desc The description of the repository.
# @param repo_version The version of the repository to use.
# @param repo_url The URL of the repository.
# @param repo_enabled Whether the repository is enabled.
# @param repo_gpgcheck Whether to check the GPG signature of the repository.
# @param repo_gpgkey The GPG key of the repository.
# @param repo_gpgkeyid The GPG key ID of the repository.
# @param package_name The name of the package.
# @param package_ensure The desired state of the package.
# @param package_provider The provider to use to manage the package.
# @param service_name The name of the service.
# @param service_ensure The desired state of the service.
# @param service_enable Whether to enable the service.
# @param service_manage Whether to manage the service.
# @param config_file The path to the configuration file.
# @param config_file_mode The file mode of the configuration file.
# @param config_path The path to the configuration directory.
# @param config_path_mode The file mode of the configuration directory.
# @param config_owner The owner of the configuration files.
# @param config_group The group of the configuration files.
# @param configs A hash of configurations to manage.
# @param plugins A hash of plugins to manage.
# @param purge_config_dir Whether to purge the configuration directory.
#
# @example
#   class { 'fluentd':
#     repo_manage => true,
#     repo_name => 'fluentd',
#     repo_desc => 'Fluentd repository',
#     repo_version => '1.0.0',
#     package_provider => 'gem',
#   }
#
# This will include the `fluentd::install`, `fluentd::config`, and `fluentd::service` classes, 
# which will manage the installation, configuration, and service of Fluentd, respectively.
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
