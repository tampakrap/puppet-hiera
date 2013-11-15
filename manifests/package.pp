class hiera::package {

  include hiera

  if $hiera::provider == 'portage' {
    portage::package { $hiera::pkgname:
      keywords => $hiera::gentoo_keywords,
      target   => 'puppet',
      ensure   => $hiera::ensure,
    }
  } else {
    package { $hiera::pkgname:
      ensure          => $hiera::ensure,
      provider        => $hiera::provider,
      install_options => $hiera::install_options,
    }
  }

  if $hiera::merge_behavior in ['deep', 'deeper'] {
    if $hiera::provider == 'portage' {
      portage::package { $hiera::deepmerge_pkgname:
        keywords => $hiera::deepmerge_gentoo_keywords,
        target   => 'puppet',
        ensure   => $hiera::deepmerge_ensure,
      }
    } else {
      package { $hiera::deepmerge_pkgname:
        ensure          => $hiera::deepmerge_ensure,
        provider        => $hiera::provider,
        install_options => $hiera::deepmerge_install_options,
      }
    }
  }

}
