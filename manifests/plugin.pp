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

  $all_install_options = $repo_version_option.merge($source_option).merge($plugin_install_options)

  notice("ALEXXXXX FROM PLUGIN.PP all_install_options: ${all_install_options}")

  fluentd::package_wrapper { $title:
    package_ensure          => $plugin_ensure,
    package_install_options => $all_install_options,
    package_provider        => $plugin_provider,
    repo_version            => $fluentd::repo_version,
    set_provider            => true,
    notify                  => Class['fluentd::service'],
    require                 => Class['fluentd::install'],
  }
}
