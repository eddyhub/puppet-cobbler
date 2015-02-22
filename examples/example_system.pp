define cobbler::example_system(
  $ensure = 'present',
  $profile = undef,
  $deploy_stage = 'dev',
  $mac_address = undef,
  $ip_address = undef,
  $gateway = '10.0.0.1',
  ) {
  if $ensure == 'present' {
    if $profile == undef {
      fail("Please specify a profile for ${title}")
    }
    elsif $mac_address == undef {
      fail("Please specify a mac address for ${title}")
    }
    elsif $ip_address == undef {
      fail("Please specify an ip address for ${title}")
    }
    cobblersystem {"${title}":
      ensure => present,
      profile => $profile,
      require => Cobblerprofile["${profile}"],
      ks_meta => {
        'stage' => $deploy_stage,
      },
      netboot => 'false',
      comment => 'System managed by puppet!',
      interfaces     => {
        'eth0' => {
          mac_address => $mac_address,
          static      => true,
          management  => false,
          ip_address  => $ip_address,
          netmask     => '255.255.0.0',
          dns_name    => $title,
        },
      },
      #in cobbler <2.4 gateway can't be specified in interfaces
      gateway     => "${gateway}",
    }
  }
  else {
    cobblersystem {"${title}":
      ensure => absent,
    }
  }
}
