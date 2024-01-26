# lib/puppet/type/tdagent.rb
Puppet::Type.newtype(:tdagent) do
  @doc = "Manages the Gem provider for Linux (tdagent / fluentd) for FluentD"

  ensurable do
    desc 'Whether this service key should be present or absent on the target system.'
    newvalues(:present, :absent)
  end

  newparam(:name, namevar: true) do
    desc 'Name of the service to register in Windows, this is the "short" name visible when looking at service properties or querying with sc.exe.'
  end

  newparam(:install_options) do
    desc 'Options to pass to the gem install command'
    defaultto []
  end

  newparam(:repo_version) do
    desc 'The version of the repository'
  end

  newparam(:source) do
    desc 'The source of the gem'
  end

  newparam(:provider) do
    desc 'The provider to use to manage the Fluentd plugin.'
    defaultto :tdagent
  end

  autorequire(:class) do
    ['fluentd::install', 'fluentd::service']
  end
end