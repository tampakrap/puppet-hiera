class hiera::package {

  package { $hiera::package_name:
    ensure          => $hiera::ensure,
    provider        => $hiera::provider,
    install_options => $hiera::install_options,
  }

  if $hiera::merge_behavior in ['deep', 'deeper'] {
    package { $hiera::deepmerge_package_name:
      ensure          => $hiera::deepmerge_ensure,
      provider        => $hiera::provider,
      install_options => $hiera::deepmerge_install_options,
    }
  }

}
