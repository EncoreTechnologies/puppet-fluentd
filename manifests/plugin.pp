# Resource for installing a FluentD plugin
define fluentd::plugin (
  String $plugin_ensure = present,
  Stdlib::Httpurl $plugin_source = 'https://rubygems.org',
  Hash $plugin_install_options = {},
  String $plugin_provider = tdagent,
  String $repo_version = '4',
) {
  $repo_version_option = { 'repo_version' => $repo_version }
  $source_option = { 'source' => $plugin_source }

  $all_install_options = [$repo_version_option, $source_option, *$plugin_install_options]

  package { $title:
    ensure          => $plugin_ensure,
    install_options => $all_install_options,
    provider        => $plugin_provider,
    notify          => Class['fluentd::service'],
    require         => Class['fluentd::install'],
  }
}
