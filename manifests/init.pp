class hiera (
  $backends                  = ['yaml'],
  $datadir                   = {yaml => '/etc/puppet/hieradata'},
  $hierarchy                 = ['common'],
  $merge_behavior            = 'native',
  $hierayaml_link            = true,
  $pkgname                   = $hiera::params::pkgname,
  $ensure                    = 'present',
  $gentoo_keywords           = $hiera::params::gentoo_keywords,
  $install_options           = $hiera::params::install_options,
  $provider                  = $hiera::params::provider,
  $deepmerge_pkgname         = $hiera::params::deepmerge_pkgname,
  $deepmerge_ensure          = 'present',
  $deepmerge_gentoo_keywords = $hiera::params::deepmerge_gentoo_keywords,
  $deepmerge_install_options = $hiera::params::deepmerge_install_options,
) inherits hiera::params {

  #validate merge_behavior

  include hiera::package
  include puppet::server

  case $puppet::server::servertype {
    'passenger': { $service = 'httpd' }
    'unicorn', 'thin': { $service = 'nginx' }
    'standalone': { $service = $puppet::server::master_service }
  }

  file { '/etc/puppet/hiera.yaml':
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    ensure  => file,
    content => template("${module_name}/puppet/hiera.yaml.erb"),
    notify  => Service[$service],
  }

  if $hierayaml_link == 'true' {
    file { '/etc/hiera.yaml':
      target => '/etc/puppet/hiera.yaml',
      ensure => link,
    }
  }

}
