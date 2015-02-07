class hiera (
  $backends                  = ['yaml'],
  $datadir                   = {yaml => '/etc/puppet/hieradata'},
  $hierarchy                 = ['common'],
  $merge_behavior            = 'native',
  $hierayaml_link            = true,
  $package_name              = $hiera::params::package_name,
  $ensure                    = 'present',
  $install_options           = undef,
  $provider                  = undef,
  $restart_puppetmaster      = false,
  $deepmerge_package_name    = $hiera::params::deepmerge_package_name,
  $deepmerge_ensure          = 'present',
  $deepmerge_install_options = undef,
) inherits hiera::params {

  #validate merge_behavior

  include hiera::package

  if $restart_puppetmaster {
    include puppet::server

    case $puppet::server::servertype {
      'passenger': { $service = 'httpd' }
      'unicorn', 'thin': { $service = 'nginx' }
      'standalone': { $service = $puppet::server::master_service }
    }
  }

  file { '/etc/puppet/hiera.yaml':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    ensure  => file,
    content => template("${module_name}/hiera.yaml.erb"),
    notify  => Service[$service],
  }

  if $hierayaml_link {
    file { '/etc/hiera.yaml':
      target => '/etc/puppet/hiera.yaml',
      ensure => link,
    }
  }
}
