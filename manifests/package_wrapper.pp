# package_wrapper.pp
define fluentd::package_wrapper (
  String            $package_ensure,
  String            $repo_version,
  Optional[String]  $package_provider = undef,
  Hash              $plugin_install_options = {},
  Boolean           $set_provider = false,
) {
  $package_name = $repo_version ? {
    '4'     => 'td-agent',
    '5'     => 'fluent-package',
    default => fail("Unsupported repo_version ${fluentd::repo_version}")
  }

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

  package { $title:
    ensure          => $fluentd::package_ensure,
    install_options => $plugin_install_options,
    provider        => $final_provider,
    require         => Class['fluentd::repo'],
  }
}
