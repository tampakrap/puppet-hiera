class hiera::params {

  $install_options           = undef
  $deepmerge_install_options = undef

  # Gentoo specific
  $gentoo_keywords           = ['~amd64', '~x86']
  $deepmerge_gentoo_keywords = ['~amd64', '~x86']

  case $::osfamily {
    'debian': {}
    'gentoo': {
      $pkgname           = 'dev-ruby/hiera'
      $provider          = 'portage'
      $deepmerge_pkgname = 'dev-ruby/deep_merge'
    }
    'redhat': {}
    'suse': {}
    'default': { fail("$::osfamily is not supported") }
  }

}
