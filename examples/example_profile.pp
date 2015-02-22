define cobbler::example_profile(
  $ensure = 'present',
  $distro = inline_template('<%=@title.sub(/-profile$/,"")%>'),
  $run_puppet = true,
  ) {
  if $ensure == 'present' {
    cobblerprofile {"${title}":
      ensure => present,
      kickstart => "${::cobbler::params::cobbler_kickstarts_dir}/${distro}.ks",
      distro => "${distro}",
      require => [
                  Cobblerdistro["${distro}"],
                  File["${::cobbler::params::cobbler_kickstarts_dir}/${distro}.ks"],
                  ],
      nameservers => ['8.8.4.4', '8.8.8.8'],
      search => "example.com",
      comment => 'Profile managed by puppet!',
      ks_meta => {
        'ntp_server' => 'ntp.example.com',
        # yes, yes i know this is stupid,
        # it looks ugly and is probably a security issue:
        # 1. using an external call here ...omfg
        # 2. using a static salt string
        # 3. using a dynamic salt is also a problem,
        # because than the puppet module isn't idempotent anymore
        'root_password' => inline_template("<%= %x(openssl passwd -1 -salt aBcDeFgH #{scope.lookupvar('::cobbler::defaultrootpw')}).chomp! %>"),
        # There is a function for this, but it doesn't work in combination with our puppet master.
        # and I have no time to debug this right now.
        # 'root_password' => unix_crypt_password("aBcDeFgH", "${::cobbler::defaultrootpw}"),
        'puppet_server' => 'master.example.com',
        'suse_reg_server' => 'https://example.com/center/regsvc',
        'apt_cacher' => 'apt-cacher.example.com:3142',
        'locale' => 'en_US',
        'run_puppet' => "${run_puppet}",
      },
      proxy => 'http://proxy.example.com:8080',
      kernel_options => {
        'ipv6.disable' => '1',
        'locale' => 'en_US',
        'console-setup/ask_detect' => 'false',
        'keyboard-configuration/layoutcode' => 'us',
        'install' => "http://${::fqdn}/cblr/ks_mirror/${distro}",
      },
    }
  }
  else {
    cobblerprofile {"${title}":
      ensure => absent
    }
  }
}
