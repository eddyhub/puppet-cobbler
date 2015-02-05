# Class: cobbler::params
#
#   The cobbler default configuration settings.
#
class cobbler::params {

  $cobbler_lib_dir = '/var/lib/cobbler'
  $cobbler_kickstarts_dir = "${cobbler_lib_dir}/kickstarts"
  $package_ensure = 'present'

  case $::osfamily {
    'RedHat': {
      $service_name       = 'cobblerd'
      $package_name        = 'cobbler'
      $package_name_web    = 'cobbler-web'
      $tftp_package        = 'tftp-server'
      $syslinux_package    = 'syslinux'
      $python_ldap_package = 'python-ldap'
      $dhcp_package        = 'dhcp'
      $dhcp_version        = 'present'
      $dhcp_service        = 'dhcpd'
      $dnsmasq_dhcp_package = 'dnsmasq'
      $dnsmasq_dhcp_service = 'dnsmasq'
      $http_config_prefix  = '/etc/httpd/conf.d'
      $proxy_config_prefix = '/etc/httpd/conf.d'
      $distro_path         = '/distro'
      $apache_service      = 'httpd'
      $default_kickstart   = "${cobbler_kickstarts_dir}/default.ks"
    }
    'Debian': {
      $service_name        = 'cobbler'
      $package_name        = 'cobbler'
      $package_name_web    = 'cobbler-web'
      $tftp_package        = 'tftpd-hpa'
      $syslinux_package    = 'syslinux'
      $python_ldap_package = 'python-ldap'
      $dhcp_package        = 'isc-dhcp-server'
      $dhcp_version        = 'present'
      $dhcp_service        = 'isc-dhcp-server'
      $dnsmasq_dhcp_package = 'dnsmasq'
      $dnsmasq_dhcp_service = 'dnsmasq'
      $http_config_prefix  = '/etc/apache2/conf.d'
      $proxy_config_prefix = '/etc/apache2/conf.d'
      $distro_path         = '/var/www/cobbler/ks_mirror'
      $apache_service      = 'apache2'
      $default_kickstart   = "${cobbler_kickstarts_dir}/ubuntu-server.preseed"
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports osfamily RedHat")
    }
  }

  # general settings
  $next_server_ip = $::ipaddress
  $server_ip      = $::ipaddress
  $puppet_server  = 'puppet'
  $puppet_version = '2'
  $nameservers    = ['8.8.8.8', '8.8.4.4']

  # dhcp options
  $manage_dhcp        = '0'
  $dhcp_option        = 'dnsmasq'
  $dhcp_dynamic_range = '0'
  $dnsmasq_dhcp_range = "10.0.0.10,10.0.0.100"

  # dns options
  $manage_dns = 0
  $dns_option = 'dnsmasq'

  # tftpd options
  $manage_tftpd = 1
  $tftpd_option = 'in_tftpd'

  # puppet integration setup
  $puppet_auto_setup                     = 1
  $sign_puppet_certs_automatically       = 1
  $remove_old_puppet_certs_automatically = 1

  # depends on apache
  # access, regulated through Proxy directive
  $allow_access = "${server_ip} ${::ipaddress} 127.0.0.1"

  # authentication settings
  $authentication      = 'configfile'
  $ldap_server         = 'grimlock.devel.redhat.com'
  $ldap_base_dn        = 'DC=devel,DC=redhat,DC=com'
  $ldap_port           = '389'
  $ldap_tls            = '1'
  $ldap_search_bind_dn = ''
  $ldap_search_passwd  = ''
  $ldap_search_prefix  = ''
}
