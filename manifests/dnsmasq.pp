#
# = Class: cobbler::dnsmasq
#
# This module manages dnsmasq for Cobbler
# https://fedorahosted.org/cobbler/
#
class cobbler::dnsmasq (
  $package            = $::cobbler::params::dnsmasq_dhcp_package,
  $service            = $::cobbler::params::dnsmasq_dhcp_service,
  $nameservers        = $::cobbler::params::nameservers,
  $subnets            = undef,
  $dnsmasq_dhcp_range = $::cobbler::params::dnsmasq_dhcp_range,
  $next_server_ip     = $::cobbler::next_server_ip,
  $default_gateway    = $::cobbler::default_gateway
) inherits cobbler::params {
  include ::cobbler

  $dhcp_interfaces    = $interfaces
  $dhcp_subnets       = $subnets

  package { $package:
    ensure => present,
  }

  service { $service:
    ensure  => running,
    name    => $service,
    require => [
      File['/etc/cobbler/dnsmasq.template'],
      Package[$package],
      Exec['cobblersync'],
    ],
  }

  file { '/etc/cobbler/dnsmasq.template':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package[$::cobbler::package_name],
    content => template('cobbler/dnsmasq.template.erb'),
    notify  => Exec['cobblersync'],
  }

}
