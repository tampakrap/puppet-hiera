class hiera (
  $backends                  = {'yaml' => '/etc/puppet/hieradata'},
  $hierarchy                 = ['common'],
  $merge_behavior            = 'native',
  $config_link               = true,
  $config_path               = '/etc/puppet/hiera.yaml',
  $config_owner              = 'root',
  $config_group              = 'root',
  $config_mode               = '0640',
  $package_name              = $hiera::params::package_name,
  $ensure                    = 'present',
  $install_options           = undef,
  $provider                  = undef,
  $deepmerge_package_name    = $hiera::params::deepmerge_package_name,
  $deepmerge_ensure          = 'present',
  $deepmerge_install_options = undef,
) inherits hiera::params {

  if $backends { validate_hash[$backends] )
  if $hierarchy { validate_array[$hierarchy] )

  if $merge_behavior {
    $merge_behavior_options = ['native', 'deep', 'deeper']
    validate_re($merge_behavior, $merge_behavior_options)
  }

  include hiera::package

  file { $config_path:
    owner   => $config_owner,
    group   => $config_group,
    mode    => $config_mode,
    ensure  => file,
    content => template("${module_name}/hiera.yaml.erb"),
    notify  => Service[$service],
  }

  if $hierayaml_link {
    file { '/etc/hiera.yaml':
      target => $config_path,
      ensure => link,
    }
  }
}
