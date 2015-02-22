class cobbler::example_cobbler_profiles() {

  cobbler::example_profile{'ubuntu-14.04.1-server-amd64-profile':}

  cobbler::example_profile{'ubuntu-12.04.5-server-amd64-profile':}

  cobbler::example_profile{'ubuntu-14.04.1-server-amd64-without-puppet-profile':
    run_puppet => false,
    distro => 'ubuntu-14.04.1-server-amd64',
  }

  cobbler::example_profile{'ubuntu-12.04.5-server-amd64-without-puppet-profile':
    run_puppet => false,
    distro => 'ubuntu-12.04.5-server-amd64',
  }
}
