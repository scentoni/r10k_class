$puppet_conf = '/etc/puppet/puppet.conf'

ini_setting { 'puppet.conf/main/dns_alt_names':
  ensure => 'present',
  path   => $puppet_conf,
  section => 'main',
  setting => 'dns_alt_names',
  value   => "puppet,puppet.${::domain},${::hostname},${::fqdn}"
}

ini_setting { 'puppet.conf/main/manifest':
  ensure  => 'present',
  path    => $puppet_conf,
  section => 'main',
  setting => 'manifest',
  value   => '/etc/puppet/environments/$environment/manifests/site.pp'
}

ini_setting { 'puppet.conf/main/modulepath':
  ensure  => 'present',
  path    => $puppet_conf,
  section => 'main',
  setting => 'modulepath',
  value   => '/etc/puppet/environments/$environment/modules:/usr/share/puppet/modules'
}

ini_setting { 'puppet.conf/main/hiera_config':
  ensure  => 'present',
  path    => $puppet_conf,
  section => 'main',
  setting => 'hiera_config',
  value   => '/etc/puppet/environments/production/hiera.yaml'
}

file { '/etc/hiera.yaml':
  ensure => 'link',
  target => 'puppet/environments/production/hiera.yaml'
}

class { 'r10k':
  remote => 'git@github.com:someuser/puppet.git',
}