# @summary Resource for installing a FluentD plugin
#
# @param plugin_ensure [String] The state of the plugin, either 'present' or 'absent'
# @param plugin_source [String] The source of the plugin, defaults to 'https://rubygems.org'
# @param plugin_install_options [Array[Variant[String, Hash]]] The options to pass to the package provider
# @param plugin_provider [String] The provider to use for the package, defaults to 'tdagent'
#
define fluentd::plugin (
  String                        $plugin_ensure = present,
  Stdlib::Httpurl               $plugin_source = 'https://rubygems.org',
  Array[Variant[String, Hash]]  $plugin_install_options = [],
  String                        $plugin_provider = tdagent,
) {
  package { $title:
    ensure          => $plugin_ensure,
    source          => $plugin_source,
    install_options => $plugin_install_options,
    provider        => $plugin_provider,
    notify          => Class['fluentd::service'],
    require         => Class['fluentd::install'],
  }
}
