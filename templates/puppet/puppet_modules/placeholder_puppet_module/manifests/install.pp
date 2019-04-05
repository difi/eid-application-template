#install.pp
class placeholder_puppet_module::install inherits placeholder_puppet_module {

  user { $placeholder_puppet_module::service_name:
    ensure => present,
    shell  => '/sbin/nologin',
    home   => '/',
  } ->
  file { "${placeholder_puppet_module::config_dir}${placeholder_puppet_module::application}":
    ensure => 'directory',
    mode   => '0755',
    owner  => $placeholder_puppet_module::service_name,
    group  => $placeholder_puppet_module::service_name,
  } ->
  file { "${placeholder_puppet_module::config_dir}${placeholder_puppet_module::application}/config":
    ensure => 'directory',
    owner  => $eplaceholder_puppet_module::service_name,
    group  => $placeholder_puppet_module::service_name,
    mode   => '0755',
  } ->
  file { "${placeholder_puppet_module::log_root}${placeholder_puppet_module::application}":
    ensure => 'directory',
    mode   => '0755',
    owner  =>  $placeholder_puppet_module::service_name,
    group  =>  $placeholder_puppet_module::service_name,
  } ->
  file { "${placeholder_puppet_module::install_dir}${placeholder_puppet_module::application}":
    ensure => 'directory',
    mode   => '0644',
    owner  =>  $placeholder_puppet_module::service_name,
    group  =>  $placeholder_puppet_module::service_name,
  }

  difilib::spring_boot_logrotate { $placeholder_puppet_module::application:
    application => $placeholder_puppet_module::application,
  }

  if ($platform::install_cron_jobs) {
    $log_cleanup_command = "find ${placeholder_puppet_module::log_root}${placeholder_puppet_module::application}/ -type f -name \"*.gz\" -mtime +7 -exec rm -f {} \\;"

    cron { "${placeholder_puppet_module::application}_log_cleanup":
      command => $log_cleanup_command,
      user    => 'root',
      hour    => '03',
      minute  => '00',
    }
  }
}
