# `fluentd::plugin` is a Puppet class that manages the installation of Fluentd plugins.
# It uses the `fluentd::package_wrapper` defined type to manage the plugin package.
#
# @param title The name of the plugin to install.
# @param plugin_ensure The version of the plugin to install.
# @param plugin_install_options A hash of options to pass to the package provider when installing the plugin.
#
# @example
#   fluentd::plugin { 'fluent-plugin-elasticsearch':
#     plugin_ensure => '1.0.0',
#     plugin_install_options => { 'install_options' => ['--no-ri', '--no-rdoc'] },
#   }
#
# This will install the 'fluent-plugin-elasticsearch' plugin with version 1.0.0. 
# The options '--no-ri' and '--no-rdoc' will be passed to the package provider when installing the plugin.
define fluentd::plugin (
  String $plugin_ensure = present,
  Stdlib::Httpurl $plugin_source = 'https://rubygems.org',
  Hash $plugin_install_options = {},
  String $plugin_provider = tdagent,
  String $repo_version = '4',
) {
  fluentd::package_wrapper { $title:
    package_ensure         => $plugin_ensure,
    plugin_install_options => $plugin_install_options,
    package_provider       => $plugin_provider,
    repo_version           => $fluentd::repo_version,
    set_provider           => true,
    notify                 => Class['fluentd::service'],
    require                => Class['fluentd::install'],
  }
}
