class hiera::params {
  case $::osfamily {
    'debian': {}
    'gentoo': {
      $package_name           = 'dev-ruby/hiera'
      $deepmerge_package_name = 'dev-ruby/deep_merge'
    }
    'redhat': {}
    'suse': {
      $package_name           = 'rubygem-hiera'
      $deepmerge_package_name = 'rubygem-deep_merge'
    }
    'default': { fail("$::osfamily is not supported") }
  }
}
