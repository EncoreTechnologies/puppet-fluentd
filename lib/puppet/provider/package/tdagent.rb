Puppet::Type.type(:package).provide :tdagent, parent: :gem, source: :gem do
  has_feature :install_options, :versionable

  def self.which_from_paths(command, paths)
    # copied/inspired by puppet/util.rb which() function
    # this allows you to pass in your own custom search paths
    paths.each do |dir|
      dest = File.expand_path(File.join(dir, command))
      return dest if FileTest.file?(dest) && FileTest.executable?(dest)
    end
    raise Puppet::Error, "Provider #{name} package command '#{command}' does not exist on this host, it couldn't be found in the following paths: #{paths}"
  end

  def self.provider_command
    # FUTURE: if this still isn't good enough in the future we could append the PATH
    #         components and look there too
    if Puppet::Util::Platform.windows?
      gem_cmd = 'fluent-gem.bat'
      search_paths = [
        # v4 and newer
        'C:\\opt\\td-agent\\bin',
        # v3 and older
        'C:\\opt\\td-agent\\embedded\\bin',
      ]
    else
      gem_cmd = gem_cmd_for_linux
      search_paths = [
        # v3, v4 and newer
        '/usr/sbin',
        # v0
        '/opt/td-agent/usr/sbin',
      ]
    end
    which_from_paths(gem_cmd, search_paths)
  end

  def self.gem_cmd_for_linux
    version = Facter.value(:repo_version)
    case version
    when '4'
      'td-agent-gem'
    else
      'fluent-gem'
    end
  end
end
