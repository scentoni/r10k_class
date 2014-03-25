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
  value   => '/etc/puppet/environments/$environment/modules:/etc/puppet/environments/$environment/dist:/etc/puppet/modules:/usr/share/puppet/modules'
}

ini_setting { 'puppet.conf/main/hiera_config':
  ensure  => 'present',
  path    => $puppet_conf,
  section => 'main',
  setting => 'hiera_config',
  value   => '/etc/puppet/environments/master/hiera.yaml'
}

ini_setting { 'puppet.conf/main/environment':
  ensure  => 'present',
  path    => $puppet_conf,
  section => 'main',
  setting => 'environment',
  value   => 'master'
}

ini_setting { 'puppet.conf/main/server':
  ensure  => 'present',
  path    => $puppet_conf,
  section => 'agent',
  setting => 'server',
  value   => 'puppet'
}

service { 'puppet':
  ensure => 'stopped',
  enable => false,
}

service { 'puppetmaster':
  ensure => 'running',
  enable => true,
}

file { '/etc/hiera.yaml':
  ensure => 'link',
  target => 'puppet/environments/master/hiera.yaml'
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

host { 'localhost.localdomain':
  ensure       => 'present',
  host_aliases => ['localhost', 'puppet'],
  ip           => '127.0.0.1',
  target       => '/etc/hosts',
}