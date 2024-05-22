# `fluentd::init` is the main entry point for the Fluentd module.
# It includes the other classes in the module and manages the Fluentd service.
#
# @param config_file_mode
#   The file mode of the configuration file.
# @param config_file
#   The path to the configuration file.
# @param config_group
#   The group of the configuration files.
# @param config_owner
#   The owner of the configuration files.
# @param config_path_mode
#   The file mode of the configuration directory.
# @param config_path
#   The path to the configuration directory.
# @param configs
#   A hash of configurations to manage.
# @param manage_user
#   Boolean to indicate management of user/group. Default true
# @param package_ensure
#   The desired state of the package.
# @param package_name
#   The name of the package.
# @param package_provider
#   The provider to use to manage the package.
# @param plugins
#   A hash of plugins to manage.
# @param purge_config_dir
#   Whether to purge the configuration directory.
# @param repo_desc
#   The description of the repository.
# @param repo_enabled
#   Whether the repository is enabled.
# @param repo_gpgcheck
#   Whether to check the GPG signature of the repository.
# @param repo_gpgkeyid
#   The GPG key ID of the repository.
# @param repo_gpgkey
#   The GPG key of the repository.
# @param repo_manage
#   Whether to manage the Fluentd repository.
# @param repo_name
#   The name of the repository.
# @param repo_url
#   The URL of the repository.
# @param repo_version
#   The version of the repository to use.
# @param service_enable
#   Whether to enable the service.
# @param service_ensure
#   The desired state of the service.
# @param service_manage
#   Whether to manage the service.
# @param service_name
#   The name of the service.
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
#
class fluentd (
  Stdlib::Absolutepath        $config_file       = $fluentd::params::config_file,
  Optional[Stdlib::Filemode]  $config_file_mode  = $fluentd::params::config_file_mode,
  String                      $config_group      = $fluentd::params::config_group,
  String                      $config_owner      = $fluentd::params::config_owner,
  Stdlib::Absolutepath        $config_path       = $fluentd::params::config_path,
  Optional[Stdlib::Filemode]  $config_path_mode  = $fluentd::params::config_path_mode,
  Hash                        $configs           = $fluentd::params::configs,
  Boolean                     $manage_user       = true,
  String                      $package_ensure    = $fluentd::params::package_ensure,
  String                      $package_name      = $fluentd::params::package_name,
  Optional[String]            $package_provider  = $fluentd::params::package_provider,
  Hash                        $plugins           = $fluentd::params::plugins,
  Boolean                     $purge_config_dir  = $fluentd::params::purge_config_dir,
  String                      $repo_desc         = $fluentd::params::repo_desc,
  Boolean                     $repo_enabled      = $fluentd::params::repo_enabled,
  Boolean                     $repo_gpgcheck     = $fluentd::params::repo_gpgcheck,
  Stdlib::Httpurl             $repo_gpgkey       = $fluentd::params::repo_gpgkey,
  String                      $repo_gpgkeyid     = $fluentd::params::repo_gpgkeyid,
  Boolean                     $repo_manage       = $fluentd::params::repo_manage,
  String                      $repo_name         = $fluentd::params::repo_name,
  Optional[Stdlib::Httpurl]   $repo_url          = undef,
  String                      $repo_version      = $fluentd::globals::repo_version,
  Boolean                     $service_enable    = $fluentd::params::service_enable,
  String                      $service_ensure    = $fluentd::params::service_ensure,
  Boolean                     $service_manage    = $fluentd::params::service_manage,
  String                      $service_name      = $fluentd::params::service_name,
) inherits fluentd::params {
  #
  $_debug = @("EOC")

        config_group: ${config_group}
         config_user: ${config_owner}
         config_file: ${config_file}
         config_path: ${config_path}
        package_name: ${package_name}
           repo_name: ${repo_name}
        repo_version: ${repo_version}
        service_name: ${service_name}

    |- EOC

  #notify { "DEBUG: ${title}":
  #  message  => $_debug,
  #  loglevel => 'warning',
  #}

  contain fluentd::install
  contain fluentd::service

  Class['fluentd::install'] -> Class['fluentd::service']

  create_resources('fluentd::plugin', $plugins)
  create_resources('fluentd::config', $configs)
}
