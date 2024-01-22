# Installs FluentD
class fluentd::install inherits fluentd {
  contain fluentd::repo

  package { $package_name:
    ensure   => $fluentd::package_ensure,
    provider => $fluentd::package_provider,
    require  => Class['fluentd::repo'],
  }

  # Ensure the parent directory exists
  file { "/etc/${fluentd::package_path}":
    ensure => directory,
    owner  => $fluentd::config_owner,
    group  => $fluentd::config_group,
    mode   => $fluentd::config_path_mode,
  }

  -> file { $fluentd::config_path:
    ensure  => directory,
    owner   => $fluentd::config_owner,
    group   => $fluentd::config_group,
    mode    => $fluentd::config_path_mode,
    recurse => $fluentd::purge_config_dir,
    force   => true,
    purge   => $fluentd::purge_config_dir,
  }

  -> file { $fluentd::config_file:
    ensure => file,
    source => 'puppet:///modules/fluentd/td-agent.conf',
    owner  => $fluentd::config_owner,
    group  => $fluentd::config_group,
    mode   => $fluentd::config_file_mode,
  }
}
