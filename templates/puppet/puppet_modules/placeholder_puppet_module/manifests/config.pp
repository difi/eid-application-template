#config.pp
class placeholder_puppet_module::config inherits placeholder_puppet_module {

  file { "${placeholder_puppet_module::install_dir}${placeholder_puppet_module::application}/${placeholder_puppet_module::artifact_id}.conf":
    ensure  => 'file',
    content => template("${module_name}/${placeholder_puppet_module::artifact_id}.conf.erb"),
    owner   => $placeholder_puppet_module::service_name,
    group   => $placeholder_puppet_module::service_name,
    mode    => '0444',
  } ->
  file { "${placeholder_puppet_module::config_dir}${placeholder_puppet_module::application}/application.yml":
    ensure  => 'file',
    content => template("${module_name}/application.yml.erb"),
    owner   => $placeholder_puppet_module::service_name,
    group   => $placeholder_puppet_module::service_name,
    mode    => '0444',
  } ->
  file { "/etc/rc.d/init.d/${placeholder_puppet_module::service_name}":
    ensure => 'link',
    target => "${placeholder_puppet_module::install_dir}${placeholder_puppet_module::application}/${placeholder_puppet_module::artifact_id}.placeholder-packaging",
  }

  difilib::logback_config { $placeholder_puppet_module::application:
    application       => $placeholder_puppet_module::application,
    owner             => $placeholder_puppet_module::service_name,
    group             => $placeholder_puppet_module::service_name,
    loglevel_no       => $placeholder_puppet_module::log_level,
    loglevel_nondifi  => $placeholder_puppet_module::log_level,
  }


}
