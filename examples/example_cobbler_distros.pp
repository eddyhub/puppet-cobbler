class cobbler::example_cobbler_distros() {
  cobbler::ubuntu_netboot_distro {'ubuntu-12.04.5-server-amd64':
    arch    => 'x86_64',
    isolink => 'http://de.archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-i386/current/images/netboot/mini.iso',
    ensure  => 'present',
  }

  cobbler::ubuntu_netboot_distro {'ubuntu-14.04.1-server-amd64':
    arch    => 'x86_64',
    isolink => 'http://de.archive.ubuntu.com/ubuntu/dists/trusty-updates/main/installer-i386/current/images/netboot/mini.iso',
    ensure  => 'present',
  }

  cobbler::sles_distro {'sles-13-x86_64':
    arch => 'x86_64',
    isolink => 'http://ftp4.gwdg.de/pub/opensuse/distribution/13.2/iso/openSUSE-13.2-DVD-x86_64.iso',
    ensure => 'present',
  }
}
