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
  value   => '/etc/puppet/environments/$environment/modules:/etc/puppet/modules:/usr/share/puppet/modules'
}

ini_setting { 'puppet.conf/main/hiera_config':
  ensure  => 'present',
  path    => $puppet_conf,
  section => 'main',
  setting => 'hiera_config',
  value   => '/etc/puppet/environments/master/hiera.yaml'
}

file { '/etc/hiera.yaml':
  ensure => 'link',
  target => 'puppet/environments/production/hiera.yaml'
}

$r10k_config = "# The location to use for storing cached Git repos
:cachedir: '/var/cache/r10k'

# A list of git repositories to create
:sources:
  # This will clone the git repository and instantiate an environment per
  # branch in /etc/puppet/environments
  :puppet:
    remote: 'git://github.com/taosmountain/r10k_class.git'
    basedir: '/etc/puppet/environments'
"

file { '/etc/r10k.yaml':
  ensure  => 'file',
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => $r10k_config,
}
