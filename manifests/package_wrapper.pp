# `fluentd::package_wrapper` is a Puppet class that installs the Fluentd package.
# It determines the package name based on the provided repository version.
#
# @param package_ensure The desired state of the package, typically 'present' or 'absent'.
# @param plugin_install_options A hash of options to pass to the package provider when installing the package.
# @param package_provider The provider to use to manage the package, typically 'gem' or 'tdagent'.
# @param repo_version The version of the repository to use, '4' for 'td-agent' and '5' for 'fluent-package'.
# @param set_provider A boolean that determines whether to set the provider for the package.
define fluentd::package_wrapper (
  String            $package_ensure,
  String            $repo_version,
  Optional[String]  $package_provider = undef,
  Hash              $plugin_install_options = {},
  Boolean           $set_provider = false,
) {
  $final_provider = $package_provider == 'chocolatey' ? {
    true    => $package_provider,
    default => $set_provider ? {
      true    => $repo_version ? {
        '4'     => 'tdagent',
        '5'     => 'fluentd',
        default => fail("Unsupported repo_version ${fluentd::repo_version}")
      },
      default => $package_provider
    }
  }

  if $final_provider == 'chocolatey' {
    $_plugin_install_options = undef
  }
  else {
    $_plugin_install_options = $plugin_install_options
  }

  # `$title` in Puppet is the name of the defined resource. In `fluentd::package_wrapper`, it's the package name.
  # In `fluentd::install`, `$fluentd::package_name` is passed as `$title`.
  # In `fluentd::plugin`, the plugin name is passed as `$title`.
  package { $title:
    ensure          => $fluentd::package_ensure,
    install_options => $_plugin_install_options,
    provider        => $final_provider,
    require         => Class['fluentd::repo'],
  }
}
