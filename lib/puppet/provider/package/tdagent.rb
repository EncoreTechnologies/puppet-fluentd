# tdagent.rb
# Custom Puppet providers for Fluentd packages.

# Provider for td-agent distribution.
Puppet::Type.type(:package).provide :tdagent, :parent => :gem do
  desc "td-agent's gem support."

  has_command(:gemcmd, 'td-agent-gem') do
    is_optional
  end

  has_features :install_options

  def self.provider_command
    command(:gemcmd)
  end
end

# Provider for Fluentd distribution.
Puppet::Type.type(:package).provide :fluentd, :parent => :gem do
  desc "fluent's gem support."

  has_command(:gemcmd, 'fluent-gem') do
    is_optional
  end

  has_features :install_options

  def self.provider_command
    command(:gemcmd)
  end
end
