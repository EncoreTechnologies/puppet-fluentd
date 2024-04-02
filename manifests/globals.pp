class fluentd::globals (
  Optional[String[1]] $config_file_name = undef,
  Optional[String[1]] $owner_group_name = undef,
  Optional[String[1]] $package_name     = undef,
  Optional[String[1]] $package_path     = undef,
  Optional[String[1]] $service_name     = undef,
  String[1]           $repo_version     = undef,
) {
  case $repo_version {
    '4': {
      $config_file_name = $config_file_name ? {
        undef => 'td-agent.conf',
        default => $config_file_name,
      }

      $owner_group_name = $owner_group_name ? {
        undef => 'td-agent',
        default => $owner_group_name,
      }

      $package_name = $package_name ? {
        undef => 'td-agent',
        default => $package_name,
      }

      $package_path = $package_path ? {
        undef => 'td-agent',
        default => $package_path,
      }

      $service_name = $service_name ? {
        undef => 'td-agent',
        default => $service_name,
      }
    }
    '5': {
      $config_file_name = $config_file_name ? {
        undef => 'fluentd.conf',
        default => $config_file_name,
      }

      $owner_group_name = $owner_group_name ? {
        undef => 'fluent',
        default => $owner_group_name,
      }

      $package_name = $package_name ? {
        undef => 'fluent-package',
        default => $package_name,
      }

      $package_path = $package_path ? {
        undef => 'fluent',
        default => $package_path,
      }

      $service_name = $service_name ? {
        undef => 'fluentd',
        default => $service_name,
      }
    }
    default: {
      fail("Unsupported repo_version: ${repo_version}")
    }
  }
}
