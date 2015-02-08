# = Class: hiera
#
# Manage hiera packages and hiera.yaml config file
#
# == Parameters:
#
# [*backends*]
# A hash with the hiera backends as key, and a hash of their data as value
# Default: {'yaml' => {'datadir' => '/etc/puppet/hieradata'} }
#
# [*hierarchy*]
# A list with the hierarchy.
# Default: empty list
#
# [*merge_behavior*]
# The merge behavior setting in the hiera.yaml
# Default: empty string
#
# [*logger*]
# The logger setting in the hiera.yaml
# Default: empty string
#
# [*config_link*]
# Whether to create or not a symlink to /etc/hiera.yaml, for cli usage
# Default: true
#
# [*config_path*]
# The absolute path to hiera.yaml
# Default: /etc/puppet/hiera.yaml
#
# [*config_owner*]
# The owner of the hiera.yaml file
# Default: root
#
# [*config_group*]
# The group of the hiera.yaml file
# Default: root
#
# [*config_mode*]
# The mode of the hiera.yaml file
# Default: 0640
#
# [*package_name*]
# The name of the hiera package
# Default: hiera or platform specific
#
# [*ensure*]
# The ensure value of the hiera package
# Default: present
#
# [*install_options*]
# The install_options of the hiera package
# Default: undef
#
# [*provider*]
# The package provider of all the packages
# Default: undef
#
# [*deep_merge_package_name*]
# The name of the deep_merge package
# Default: deep_merge or platform specific
#
# [*deep_merge_ensure*]
# The ensure value of the deep_merge package
# Default: present
#
# [*deep_merge_install_options*]
# The install_options of the deep_merge package
# Default: undef
#
# [*eyaml_package_name*]
# The name of the eyaml package
# Default: hiera-eyaml or platform specific
#
# [*eyaml_ensure*]
# The ensure value of the eyaml package
# Default: present
#
# [*eyaml_install_options*]
# The install_options of the eyaml package
# Default: undef
#
# [*eyaml_gpg_package_name*]
# The name of the eyaml-gpg package
# Default: hiera-eyaml-gpg or platform specific
#
# [*eyaml_gpg_ensure*]
# The ensure value of the eyaml-gpg package
# Default: present
#
# [*eyaml_gpg_install_options*]
# The install_options of the eyaml-gpg package
# Default: undef
#
# [*hiera_gpg_package_name*]
# The name of the hiera-gpg package
# Default: hiera-gpg or platform specific
#
# [*hiera_gpg_ensure*]
# The ensure value of the hiera-gpg package
# Default: present
#
# [*hiera_gpg_install_options*]
# The install_options of the hiera-gpg package
# Default: undef
#
# == Example:
#
#    class { 'hiera':
#      hierarchy => [
#        'node/_percent_{::fqdn}',
#        'common',
#      ],
#      merge_behavior => 'deep',
#    }
#
# == See also:
#
# tests/init.pp for a more complex scenario
#
#
class hiera (
  $backends                   = {'yaml' => {'datadir' => '/etc/puppet/hieradata'} },
  $hierarchy                  = [],
  $merge_behavior             = '',
  $logger                     = '',
  $config_link                = true,
  $config_path                = '/etc/puppet/hiera.yaml',
  $config_owner               = 'root',
  $config_group               = 'root',
  $config_mode                = '0640',
  $package_name               = $hiera::params::package_name,
  $ensure                     = 'present',
  $install_options            = undef,
  $provider                   = undef,
  $deep_merge_package_name    = $hiera::params::deep_merge_package_name,
  $deep_merge_ensure          = 'present',
  $deep_merge_install_options = undef,
  $eyaml_package_name         = $hiera::params::eyaml_package_name,
  $eyaml_ensure               = 'present',
  $eyaml_install_options      = undef,
  $eyaml_gpg_package_name     = $hiera::params::eyaml_gpg_package_name,
  $eyaml_gpg_ensure           = 'present',
  $eyaml_gpg_install_options  = undef,
  $hiera_gpg_package_name     = $hiera::params::hiera_gpg_package_name,
  $hiera_gpg_ensure           = 'present',
  $hiera_gpg_install_options  = undef,
) inherits hiera::params {

  if $backends { validate_hash($backends) }
  if $hierarchy { validate_array($hierarchy) }
  validate_bool($config_link)

  if $merge_behavior {
    $merge_behavior_options = ['native', 'deep', 'deeper']
    validate_re($merge_behavior, $merge_behavior_options)
  }

  include hiera::package

  file { $config_path:
    ensure  => file,
    owner   => $config_owner,
    group   => $config_group,
    mode    => $config_mode,
    content => template("${module_name}/hiera.yaml.erb"),
  }

  if $config_link {
    file { '/etc/hiera.yaml':
      ensure => link,
      target => $config_path,
    }
  }
}
