# tdagent.rb
# Custom Puppet providers for Fluentd packages.

# Provider for td-agent distribution.
Puppet::Type.type(:package).provide :tdagent, :parent => :gem do
  desc "td-agent's gem support."

  has_command(:gemcmd, 'td-agent-gem') do
    is_optional
  end

  has_features :install_options

  def self.which_from_paths(command, paths)
    paths.each do |dir|
      dest = File.expand_path(File.join(dir, command))
      return dest if FileTest.file?(dest) && FileTest.executable?(dest)
    end
    raise Puppet::Error, "Provider #{name} package command '#{command}' does not exist on this host, it couldn't be found in the following paths: #{paths}"
  end

  def self.provider_command
    if Puppet::Util::Platform.windows?
      gem_cmd = 'fluent-gem.bat'
      search_paths = [
        'C:\\opt\\td-agent\\bin',
        'C:\\opt\\td-agent\\embedded\\bin',
      ]
    else
      gem_cmd = 'td-agent-gem'
      search_paths = [
        '/usr/sbin',
        '/opt/td-agent/usr/sbin',
      ]
    end
    which_from_paths(gem_cmd, search_paths)
  end
end

# Provider for Fluentd distribution.
Puppet::Type.type(:package).provide :fluentd, :parent => :gem do
  desc "fluent's gem support."

  has_command(:gemcmd, 'fluent-gem') do
    is_optional
  end

  has_features :install_options

  def self.which_from_paths(command, paths)
    paths.each do |dir|
      dest = File.expand_path(File.join(dir, command))
      return dest if FileTest.file?(dest) && FileTest.executable?(dest)
    end
    raise Puppet::Error, "Provider #{name} package command '#{command}' does not exist on this host, it couldn't be found in the following paths: #{paths}"
  end

  def self.provider_command
    if Puppet::Util::Platform.windows?
      gem_cmd = 'fluent-gem.bat'
      search_paths = [
        'C:\\opt\\td-agent\\bin',
        'C:\\opt\\td-agent\\embedded\\bin',
      ]
    else
      gem_cmd = 'fluent-gem'
      search_paths = [
        '/usr/sbin',
        '/opt/td-agent/usr/sbin',
      ]
    end
    which_from_paths(gem_cmd, search_paths)
  end
end