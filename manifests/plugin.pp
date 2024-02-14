# `fluentd::plugin` is a Puppet class that manages the installation of Fluentd plugins.
# It uses the `fluentd::package_wrapper` defined type to manage the plugin package.
#
# @param title The name of the plugin to install.
# @param plugin_ensure The version of the plugin to install.
# @param plugin_install_options A hash of options to pass to the package provider when installing the plugin.
# @param plugin_source The source URL from where the plugin will be downloaded. Default is 'https://rubygems.org'.
# @param plugin_provider The provider that will be used to install the plugin. Default is 'tdagent'.
# @param repo_version The version of the repository where the plugin is located. Default is '4'.
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
  # `$title` is the name of the Fluentd plugin to install.
  # It's passed to `fluentd::package_wrapper` to manage the plugin package.
  # The value of `$title` is determined by the name you give to the `fluentd::plugin` resource when you declare it.
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
