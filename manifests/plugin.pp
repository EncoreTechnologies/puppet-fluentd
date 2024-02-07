# plugin.pp
define fluentd::plugin (
  String $plugin_ensure = present,
  Stdlib::Httpurl $plugin_source = 'https://rubygems.org',
  Hash $plugin_install_options = {},
  String $plugin_provider = $facts['os']['family'] ? {
    'windows' => 'chocolatey',
    default   => 'tdagent'
  },
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
