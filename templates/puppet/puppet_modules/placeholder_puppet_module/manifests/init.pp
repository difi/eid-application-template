class placeholder_puppet_module (
  String $log_root                                 = $placeholder_puppet_module::params::log_root,
  String $log_level                                = $placeholder_puppet_module::params::log_level,
  String $install_dir                              = $placeholder_puppet_module::params::install_dir,
  String $config_dir                               = $placeholder_puppet_module::params::config_dir,
  String $group_id                                 = $placeholder_puppet_module::params::group_id,
  $artifact_id                              = $placeholder_puppet_module::params::artifact_id,
  $service_name                             = $placeholder_puppet_module::params::service_name,
  $server_port                              = $placeholder_puppet_module::params::server_port,
  $application                              = $placeholder_puppet_module::params::application,
  $server_tomcat_max_threads                = $placeholder_puppet_module::params::server_tomcat_max_threads,
  $server_tomcat_min_spare_threads          = $placeholder_puppet_module::params::server_tomcat_min_spare_threads,
  $health_show_details                      = $placeholder_puppet_module::params::health_show_details,
  $auditlog_dir                             = $placeholder_puppet_module::params::auditlog_dir,
  $auditlog_file                            = $placeholder_puppet_module::params::auditlog_file,

)inherits placeholder_puppet_module::params {

  include platform

  anchor { 'placeholder_puppet_module::begin': } ->
  class { '::placeholder_puppet_module::install': } ->
  class { '::placeholder_puppet_module::deploy': } ->
  class { '::placeholder_puppet_module::config': } ~>
  class { '::placeholder_puppet_module::service': } ->
  anchor { 'placeholder_puppet_module::end': }

}
