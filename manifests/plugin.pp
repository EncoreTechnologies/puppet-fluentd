# Resource for installing a FluentD plugin
define fluentd::plugin (
  String $plugin_ensure = present,
  Stdlib::Httpurl $plugin_source = 'https://rubygems.org',
  Array[Variant[String, Hash]] $plugin_install_options = [],
  String $plugin_provider = tdagent,
  String $repo_version = '4',
) {
  package { $title:
    ensure          => $plugin_ensure,
    source          => $plugin_source,
    install_options => $plugin_install_options,
    repo_version    => $repo_version,
    provider        => $plugin_provider,
    notify          => Class['fluentd::service'],
    require         => Class['fluentd::install'],
  }
}
