require 'puppet/resource_api'

# Manages the Windows Service registration for FluentD
Puppet::ResourceApi.register_type(
  name: 'tdagent',
  desc: <<-EOS,
    Manages the Gem provider for Linux (tdagent / fluentd) for FluentD
  EOS
  # specify this simple_get_filter so we don't have to query for _all_ instances
  # of the service recovery resources (slow)
  features: ['simple_get_filter', 'supports_noop'],
  attributes: {
    ensure: {
        type: 'Enum[present, absent]',
        desc: 'Whether this service key should be present or absent on the target system.',
    },
    install_options: {
      type: 'Array[Variant[String, Hash]]',
      desc: 'Options to pass to the gem install command',
      behavior: :parameter,
      default: [],
    },
    name: {
      type:      'String[1]',
      behaviour: :namevar,
      desc:      'Name of the service to register in Windows, this is the "short" name visible when looking at service properties or querying with sc.exe.',
    },
    repo_version: {
      type: 'String',
      desc: 'The version of the repository',
      behavior: :parameter,
    },
    source: {
      type: 'Optional[String]',
      desc: 'The source of the gem',
      behavior: :parameter,
    },
  },
)
