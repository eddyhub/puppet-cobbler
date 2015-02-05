#
# = Define: cobbler::sles_distro
# This class adds sles distros and a kickstart file with the same name
define cobbler::sles_distro (
  $ensure            = 'present',
  $arch,
  $isolink,
  $ks_meta           = {'tree' => "http://@@http_server@@/cblr/ks_mirror/${title}",},
  $kernel            = 'boot/x86_64/loader/linux',
  $initrd            = 'boot/x86_64/loader/initrd',
  $ks_template       = "cobbler/${title}.ks.erb",
  $include_kickstart = true,
  $breed             = 'suse',
  ) {
  include ::cobbler

  $distro = $title
  $server_ip = $::cobbler::server_ip
  if $ensure == 'absent' {
    cobblerdistro { $distro :
      ensure  => absent,
      require => [ Service['cobbler'], Service['httpd'] ],
    }
    file { "${::cobbler::params::cobbler_kickstarts_dir}/${distro}.ks":
      ensure  => absent,
      require => File["${::cobbler::params::cobbler_kickstarts_dir}"],
    }
  }
  else {
    cobblerdistro { $distro :
      ensure  => present,
      arch    => $arch,
      isolink => $isolink,
      destdir => $::cobbler::distro_path,
      ks_meta => $ks_meta,
      kernel  => "${::cobbler::distro_path}/${distro}/${kernel}",
      initrd  => "${::cobbler::distro_path}/${distro}/${initrd}",
      breed   => $breed,
      comment => 'Managed by puppet!',
      require => [ Service['cobbler'], Service['httpd'] ],
    }
    $defaultrootpw = $::cobbler::defaultrootpw
    if ($include_kickstart) {
      file { "${::cobbler::params::cobbler_kickstarts_dir}/${distro}.ks":
        ensure  => present,
        content => template($ks_template),
        require => File["${::cobbler::params::cobbler_kickstarts_dir}"],
      }
    }
  }
}
