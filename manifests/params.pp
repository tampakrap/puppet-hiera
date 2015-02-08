class hiera::params {
  case $::osfamily {
    'default': {
      $package_name           = 'hiera'
      $hiera_gpg_package_name = 'hiera-gpg'
      $eyaml_package_name     = 'hiera-eyaml'
      $eyaml_gpg_package_name = 'hiera-eyaml-gpg'
  }
}
