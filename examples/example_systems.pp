class cobbler::example_systems() {
  include cobbler::example_cobbler_distros
  include cobbler::example_cobbler_profiles

  cobbler::example_system{'host0001.example.com':
    profile      => 'ubuntu-12.04.5-server-amd64-profile',
    deploy_stage => 'dev',
    mac_address  => '11:11:11:11:11:11',
    ip_address   => '10.0.0.10',
  }
}
