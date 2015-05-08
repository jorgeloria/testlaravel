Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

exec { 'nameserver':
	command => 'echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null'
}

exec { 'timezone':
	command => 'echo "America/Chicago" | sudo tee /etc/timezone'
}

exec { 'apt-get update':
	command   => 'apt-get update',
	logoutput => true,
	require   => [
		Exec["nameserver"],
		Exec["timezone"],
	],
}

package { 'python-software-properties' :
	ensure  => 'present',
	require => Exec["apt-get update"],
}



class { 'php' : 
	# Add this repo to have PHP 5.4
	repository => "ppa:ondrej/php5",
}

class { 'apache' :
	servername => "localhost",
}

class { 'mysql' :
	password => "root",
	database => "db_laravel4admin",
}
	
class { 'sendmail' : }

class { 'composer':
  command_name => 'composer',
  target_dir   => '/usr/local/bin', 
  auto_update => true, 
  stage => last,
}

stage { 'last': }
Stage['main'] -> Stage['last']