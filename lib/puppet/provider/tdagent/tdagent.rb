Puppet::Type.type(:tdagent).provide(:tdagent, parent: Puppet::Provider::Package::Gem) do
  desc 'TD Agent provider'

  def self.which_from_paths(command, paths)
    paths.each do |dir|
      dest = File.expand_path(File.join(dir, command))
      return dest if FileTest.file?(dest) && FileTest.executable?(dest)
    end
    raise Puppet::Error, "Provider #{name} package command '#{command}' does not exist on this host, it couldn't be found in the following paths: #{paths}"
  end

  def self.provider_command(repo_version)
    if Puppet::Util::Platform.windows?
      tdagent_cmd = 'fluent-gem.bat'
      search_paths = [
        'C:\\opt\\td-agent\\bin',
        'C:\\opt\\td-agent\\embedded\\bin',
      ]
    else
      tdagent_cmd = tdagent_cmd_for_linux(repo_version)
      search_paths = [
        '/usr/sbin',
        '/opt/td-agent/usr/sbin',
      ]
    end
    which_from_paths(tdagent_cmd, search_paths)
  end
  
  def self.tdagent_cmd_for_linux(repo_version)
    case repo_version
    when '4'
      'td-agent-gem'
    else
      'fluent-gem'
    end
  end
  
  def create
    system(self.class.provider_command(resource[:repo_version]), 'gem', 'install', resource[:name], '-v', resource[:ensure], '--source', resource[:source], *resource[:install_options])
  end
  
  def destroy
    system(self.class.provider_command(resource[:repo_version]), 'gem', 'uninstall', resource[:name])
  end
  
  def exists?
    output = `#{self.class.provider_command(resource[:repo_version])} gem list --local`
    output.include?(resource[:name])
  end
  
  def version
    output = `#{self.class.provider_command(resource[:repo_version])} gem list --local`
    match = output.match(/#{Regexp.escape(resource[:name])}\s+\((\S+)\)/)
    match[1] if match
  end
end