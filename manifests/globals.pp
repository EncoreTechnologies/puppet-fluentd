# The fluentd::globals class
#
# @summary This class is meant to be used for globally overriding default parameters
# in the fluentd module.
#
# @param _config_file_name
#   The name of the configuration file. Defaults to 'td-agent.conf' for repo_version '4' and 'fluentd.conf' for repo_version '5'.
# @param _owner_group_name
#   The name of the owner group. Defaults to 'td-agent' for repo_version '4' and 'fluent' for repo_version '5'.
# @param _package_name
#   The name of the package. Defaults to 'td-agent' for repo_version '4' and 'fluent-package' for repo_version '5'.
# @param _package_path
#   The path of the package. Defaults to 'td-agent' for repo_version '4' and 'fluent' for repo_version '5'.
# @param _service_name
#   The name of the service. Defaults to 'td-agent' for repo_version '4' and 'fluentd' for repo_version '5'.
# @param repo_version
#   The version of the repository. This is used to determine the default values for the other parameters.
#
class fluentd::globals (
  Optional[String[1]]  $_config_file_name  = undef,
  Optional[String[1]]  $_owner_group_name  = undef,
  Optional[String[1]]  $_package_name      = undef,
  Optional[String[1]]  $_package_path      = undef,
  Optional[String[1]]  $_service_name      = undef,
  String[1]            $repo_version       = undef,
) {
  $config_file_name = $_config_file_name ? {
    undef   => $repo_version ? {
      '4'   => 'td-agent.conf',
      '5'   => 'fluentd.conf',
      default => fail("Unsupported repo_version: ${repo_version}")
    },
    default => $_config_file_name,
  }

  $owner_group_name = $_owner_group_name ? {
    undef   => $repo_version ? {
      '4'   => 'td-agent',
      '5'   => 'fluentd',
      default => fail("Unsupported repo_version: ${repo_version}")
    },
    default => $_owner_group_name,
  }

  $package_name = $_package_name ? {
    undef   => $repo_version ? {
      '4'   => 'td-agent',
      '5'   => 'fluent-package',
      default => fail("Unsupported repo_version: ${repo_version}")
    },
    default => $_package_name,
  }

  $package_path = $_package_path ? {
    undef   => $repo_version ? {
      '4'   => 'td-agent',
      '5'   => 'fluent',
      default => fail("Unsupported repo_version: ${repo_version}")
    },
    default => $_package_path,
  }

  $service_name = $_service_name ? {
    undef   => $repo_version ? {
      '4'   => 'td-agent',
      '5'   => 'fluentd',
      default => fail("Unsupported repo_version: ${repo_version}")
    },
    default => $_service_name,
  }
}
