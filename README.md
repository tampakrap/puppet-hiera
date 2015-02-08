puppet-hiera
=============

[![Build Status](https://travis-ci.org/tampakrap/puppet-hiera.png?branch=master)](https://travis-ci.org/tampakrap/puppet-hiera)
[![Puppet Forge](http://img.shields.io/puppetforge/v/tampakrap/hiera.svg)](https://forge.puppetlabs.com/tampakrap/hiera)

Manage hiera packages and hiera.yaml config file.

This module is heavily inspired by [hunner/hiera](https://github.com/hunner/puppet-hiera)

## Usage

By importing this module, it will create a minimal `/etc/puppet/hiera.yaml`
config. For a more complex scenario:

    class { 'hiera':
      backends       => {
        'yaml'  => {'datadir' => '/etc/puppet/environments/_percent_{::environment}/hieradata'},
        'eyaml' => {
          'datadir'           => '/etc/puppet/secret_hieradata',
          'pkcs7_private_key' => '/path/to/private_key.pkcs7.pem',
          'pkcs7_public_key'  => '/path/to/public_key.pkcs7.pem',
        }
      },
      hierarchy      => [
        'is_virtual/_percent_{::is_virtual}',
        'node/_percent_{::fqdn}',
        'common',
      ],
      merge_behavior => 'deeper',
      logger         => 'console',
      provider       => 'gem',
      ensure         => 'latest',

The above will put the following contents in `hiera.yaml`:

    ---
    :backends:
      - yaml
      - eyaml
    :yaml:
      :datadir: /etc/puppet/environments/%{::environment}/hieradata
    :eyaml:
      :datadir: /etc/puppet/secret_hieradata
      :pkcs7_private_key: /path/to/private_key.pkcs7.pem
      :pkcs7_public_key: /path/to/public_key.pkcs7.pem
    :hierarchy:
      - "is_virtual/%{::is_virtual}"
      - "node/%{::fqdn}"
      - common
    :merge_behavior: deeper
    :logger: console
    :provider: gem
    :ensure: latest

* In case you specify the `gpg` or `eyaml` backends, this module will
  automatically install the `hiera-gpg` or the `hiera-eyaml` package
  accordingly.
* In case you specify `gpg_gnupghome` under the eyaml data, then this module
  will automatically install the `hiera-eyaml-gpg` package.
* In case you specify `deep` or `deeper` merge\_behavior, then this module will
  automatically install the `deep_merge` package.

### Classes

#### Public Classes
- `hiera`: Main class to configure hiera

#### Private Classes
- `hiera::params`: Handles variable conditionals
- `hiera::package`: Handles packages' installations

### Parameters

The following parameters are available for the hiera class:

#### `backends`
A hash with the hiera backends as key, and a hash of their data as value. Default: `{'yaml' => {'datadir' => '/etc/puppet/hieradata'} }`
#### `hierarchy`
A list with the hierarchy. Default: empty list
#### `merge_behavior`
The merge behavior setting in the hiera.yaml. Default: empty string
#### `logger`
The logger setting in the `hiera.yaml`. Default: empty string
#### `config_link`
Whether to create or not a symlink to `/etc/hiera.yaml`, for cli usage. Default: true
#### `config_path`
The absolute path to `hiera.yaml`. Default: `/etc/puppet/hiera.yaml`
#### `config_owner`
The owner of the `hiera.yaml` file. Default: puppet
#### `config_group`
The group of the `hiera.yaml` file. Default: puppet
#### `config_mode`
The mode of the `hiera.yaml` file. Default: 0640
#### `package_name`
The name of the hiera package. Default: hiera or platform specific
#### `ensure`
The ensure value of the hiera package. Default: present
#### `install_options`
The install\_options of the hiera package. Default: undef
#### `provider`
The package provider of all the packages. Default: undef
#### `deep_merge_package_name`
The name of the deep\_merge package. Default: deep\_merge or platform specific
#### `deep_merge_ensure`
The ensure value of the deep\_merge package. Default: present
#### `deep_merge_install_options`
The install\_options of the deep\_merge package. Default: undef
#### `eyaml_package_name`
The name of the eyaml package. Default: hiera-eyaml or platform specific
#### `eyaml_ensure`
The ensure value of the eyaml package. Default: present
#### `eyaml_install_options`
The install\_options of the eyaml package. Default: undef
#### `eyaml_gpg_package_name`
The name of the eyaml-gpg package. Default: hiera-eyaml-gpg or platform specific
#### `eyaml_gpg_ensure`
The ensure value of the eyaml-gpg package. Default: present
#### `eyaml_gpg_install_options`
The install\_options of the eyaml-gpg package. Default: undef
#### `hiera_gpg_package_name`
The name of the hiera-gpg package. Default: hiera-gpg or platform specific
#### `hiera_gpg_ensure`
The ensure value of the hiera-gpg package. Default: present
#### `hiera_gpg_install_options`
The install\_options of the hiera-gpg package. Default: undef
