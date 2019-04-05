#service.pp
class placeholder_puppet_module::service inherits placeholder_puppet_module {

  include platform

  if ($platform::deploy_spring_boot) {
    service { $placeholder_puppet_module::service_name:
      ensure => running,
      enable => true,
    }
  }
}
