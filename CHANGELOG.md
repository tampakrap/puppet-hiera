CHANGELOG
=========

0.2.0
-----

2015-12-04

* [PR #1](https://github.com/tampakrap/puppet-hiera/pull/1): Add options to
  install the gpgme package, thanks to
  [Mark McKinstry](https://github.com/mmckinst)
* Optionally restart the web server that serves the Puppet Master, every time
  the hiera.yaml changes. Introduces optional dependency to
  [ploperations/puppet](https://github.com/puppetlabs-operations/puppet-puppet)

0.1.0
-----

2015-02-08

* Initial release
* Heavily inspired by [hunner/hiera](https://github.com/hunner/puppet-hiera)
