#params.pp
class placeholder_puppet_module::params {

  $log_root                         = '/var/log/'
  $log_level                        = 'WARN'
  $install_dir                      = '/opt/'
  $config_dir                       = '/etc/opt/'
  $group_id                         = 'placeholder-group-id'
  $artifact_id                      = 'placeholder-artifact-name'
  $service_name                     = 'placeholder-app-name'
  $server_port                      = ''
  $application                      = 'placeholder-app-name'
  $server_tomcat_max_threads        = 200
  $server_tomcat_min_spare_threads  = 10
  $health_show_details              = 'always'

  $auditlog_dir                 = '/var/log/placeholder-app-name/audit/'
  $auditlog_file                = 'audit.log'

}
