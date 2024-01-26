Puppet::Type.type(:package).provide(:tdagent, parent: Puppet::Type.type(:package).provide(:gem)) do
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
  
  def package_name
    resource[:repo_version] == '4' ? 'td-agent' : 'fluentd'
  end
  
  def create
    command = [self.class.provider_command(resource[:repo_version]), 'install', resource[:title]]
    command += ['-v', resource[:ensure]] unless resource[:ensure].nil? || resource[:ensure] == 'present'
    command += ['--source', resource[:source]] unless resource[:source].nil?
    
    Array(resource[:install_options]).each do |option|
      case option
      when String
        command << option
      when Hash
        option.each do |key, value|
          command << "--#{key}=#{value}"
        end
      end
    end
    
    system(*command)
  end
  
  def destroy
    command = [self.class.provider_command(resource[:repo_version]), 'uninstall', resource[:title]]
    system(*command) or raise "Command failed: #{command.join(' ')}"
  end
  
  def exists?
    output = `#{self.class.provider_command(resource[:repo_version])} list --local`
    puts "exists? output: #{output}"
    output.include?(resource[:title])
  end
  
  def version
    output = `#{self.class.provider_command(resource[:repo_version])} list --local`
    puts "exists? output: #{output}"
    match = output.match(/#{Regexp.escape(resource[:name])}\s+\((\S+)\)/)
    match[1] if match
  end
end