# `fluentd::install` is a Puppet class that manages the installation of Fluentd.
# It uses the `fluentd::package_wrapper` defined type to manage the Fluentd package.
class fluentd::install {
  include fluentd
  contain fluentd::repo

# Ensure the user exists
  if $fluentd::config_owner and $fluentd::manage_user_group {
    user { $fluentd::config_owner:
      ensure => present,
      before => File[$fluentd::parent_path],
    }
  }

  # Ensure the group exists
  if $fluentd::config_group and $fluentd::manage_user_group {
    group { $fluentd::config_group:
      ensure => present,
      before => File[$fluentd::parent_path],
    }
  }

  if $facts['os']['family'] == 'windows' {
    fluentd::package_wrapper { $fluentd::package_name:
      package_ensure   => $fluentd::package_ensure,
      package_provider => $fluentd::package_provider,
      repo_version     => $fluentd::repo_version,
      require          => Class['fluentd::repo'],
    }
  } else {
    fluentd::package_wrapper { $fluentd::package_name:
      package_ensure   => $fluentd::package_ensure,
      package_provider => $fluentd::package_provider,
      repo_version     => $fluentd::repo_version,
      require          => Class['fluentd::repo'],
    }
  }

  # Ensure the parent directory exists
  file { $fluentd::parent_path:
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
    source => "puppet:///modules/fluentd/${fluentd::config_file_name}",
    owner  => $fluentd::config_owner,
    group  => $fluentd::config_group,
    mode   => $fluentd::config_file_mode,
  }
}
