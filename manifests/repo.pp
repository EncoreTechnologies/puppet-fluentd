# This file defines a Puppet class for managing the FluentD repository.
# It sets the repository source and key based on the operating system.
# It also manages the repository package using the package resource type.
class fluentd::repo {
  include fluentd

  if $fluentd::repo_manage {
    $version = $fluentd::repo_version
    case $facts['os']['family'] {
      'RedHat': {
        $os_name = $facts['os']['name'] ? {
          'Amazon' => 'amazon',
          default  => 'redhat',
        }

        $repo_url = pick($fluentd::repo_url,
        "https://packages.treasuredata.com/${version}/${os_name}/\$releasever/\$basearch")
        yumrepo { $fluentd::repo_name:
          descr    => $fluentd::repo_desc,
          baseurl  => $repo_url,
          enabled  => $fluentd::repo_enabled,
          gpgcheck => $fluentd::repo_gpgcheck,
          gpgkey   => $fluentd::repo_gpgkey,
          notify   => Exec['rpmkey'],
        }

        exec { 'rpmkey':
          command     => "rpm --import ${fluentd::repo_gpgkey}",
          path        => '/bin:/usr/bin',
          refreshonly => true,
        }
      }
      'Debian': {
        $distro_id = downcase($facts['os']['name'])
        $distro_codename = $facts['os']['distro']['codename']
        $repo_url = pick($fluentd::repo_url,
        "https://packages.treasuredata.com/${version}/${distro_id}/${distro_codename}/")

        apt::source { $fluentd::repo_name:
          location     => $repo_url,
          comment      => $fluentd::repo_desc,
          repos        => 'contrib',
          architecture => 'amd64',
          release      => $distro_codename,
          key          => {
            id     => $fluentd::repo_gpgkeyid,
            source => $fluentd::repo_gpgkey,
          },
          include      => {
            'src' => false,
            'deb' => true,
          },
        }

        Class['Apt::Update'] -> Package[$fluentd::package_name]
      }
      default: {
        fail("Unsupported os family: ${facts['os']['family']}")
      }
    }
  }
}
