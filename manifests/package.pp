# Private class for packages' installations
class hiera::package {
  package { $hiera::package_name:
    ensure          => $hiera::ensure,
    provider        => $hiera::provider,
    install_options => $hiera::install_options,
  }

  if $hiera::merge_behavior in ['deep', 'deeper'] {
    package { $hiera::deep_merge_package_name:
      ensure          => $hiera::deep_merge_ensure,
      provider        => $hiera::provider,
      install_options => $hiera::deep_merge_install_options,
    }
  }

  if 'gpg' in keys($hiera::backends) {
    package { $hiera::hiera_gpg_package_name:
      ensure          => $hiera::hiera_gpg_ensure,
      provider        => $hiera::provider,
      install_options => $hiera::hiera_gpg_install_options,
    }
  } elsif 'eyaml' in keys($hiera::backends) {
    package { $hiera::eyaml_package_name:
      ensure          => $hiera::eyaml_ensure,
      provider        => $hiera::provider,
      install_options => $hiera::eyaml_install_options,
    }

    if 'gpg_gnupghome' in keys($hiera::backends['eyaml']) {
      package { $hiera::eyaml_gpg_package_name:
        ensure          => $hiera::eyaml_gpg_ensure,
        provider        => $hiera::provider,
        install_options => $hiera::eyaml_gpg_install_options,
      }
      package { $hiera::ruby_gpg_package_name:
        ensure          => $hiera::ruby_gpg_ensure,
        provider        => $hiera::provider,
        install_options => $hiera::ruby_gpg_install_options,
      }
    }
  }
}
