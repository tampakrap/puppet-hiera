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

  if 'gpg' in $hiera::backends.keys {
    package { $hiera::hiera_gpg_package_name:
      ensure          => $hiera::hiera_gpg_ensure,
      provider        => $hiera::provider,
      install_options => $hiera::hiera_gpg_install_options,
    }
  } elsif 'eyaml' in $hiera::backends.keys {
    package { $hiera::eyaml_package_name:
      ensure          => $hiera::eyaml_ensure,
      provider        => $hiera::provider,
      install_options => $hiera::eyaml_install_options,
    }

    if 'gpg_gnupghome' in $hiera::backends.keys['eyaml'].values {
      package { $hiera::eyaml_package_name:
        ensure          => $hiera::eyaml_gpg_ensure,
        provider        => $hiera::provider,
        install_options => $hiera::eyaml_gpg_install_options,
      }
    }
  }
}
