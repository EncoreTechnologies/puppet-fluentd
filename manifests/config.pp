# @summary Resource for populating a FluentD config
#
# @api private
#
define fluentd::config (
  Data $config
) {
  include fluentd

  file { "${fluentd::config_path}/${title}":
    ensure  => file,
    content => fluent_config($config),
    owner   => $fluentd::config_owner,
    group   => $fluentd::config_group,
    mode    => $fluentd::config_file_mode,
    require => Class['fluentd::install'],
    notify  => Class['fluentd::service'],
  }
}
