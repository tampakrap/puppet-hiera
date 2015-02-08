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
}
