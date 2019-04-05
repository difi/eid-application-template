#deploy.pp
class placeholder_puppet_module::deploy inherits placeholder_puppet_module {

  difilib::spring_boot_deploy { $placeholder_puppet_module::application:
    package      => $placeholder_puppet_module::group_id,
    artifact     => $placeholder_puppet_module::artifact_id,
    service_name => $placeholder_puppet_module::service_name,
    install_dir  => "${placeholder_puppet_module::install_dir}${placeholder_puppet_module::application}",
  }
}
