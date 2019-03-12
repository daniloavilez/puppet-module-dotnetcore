# Class: netcore::install
#
#
class netcore::install(
    $version = $::netcore::version,
) inherits netcore {

    case $facts['os']['family'] {
        'Debian': {
            if $facts['os']['release']['major'] == '18.04' {
                exec { 'wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb': 
                    path => [ '/usr/bin', '/usr/sbin' ],
                    notify => Exec['install-package-deb'],
                }
            }elsif $facts['os']['release']['major'] == '16.04' {
                exec { 'wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb': 
                    path => [ '/usr/bin', '/usr/sbin' ],
                    notify => Exec['install-package-deb'],
                }
            }elsif $facts['os']['release']['major'] == '14.04' {
                exec { 'wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb': 
                    path => [ '/usr/bin', '/usr/sbin' ],
                    notify => Exec['install-package-deb'],
                }
            }

            exec { 'install-package-deb': 
                command => 'sudo dpkg -i packages-microsoft-prod.deb',
                path => [ '/usr/bin', '/usr/sbin' ],
                notify => Package['apt-transport-https'],
            }

            package { 'apt-transport-https':
                ensure => installed,
                notify => Exec['update'],
            }

            exec { 'update': 
                command => 'sudo apt-get update',
                path => [ '/usr/bin', '/usr/sbin' ],
            }
        }
        'RedHat': {
            if $facts['os']['release']['major'] == '7' {
                exec { 'sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm': 
                    path => [ '/usr/bin', '/usr/sbin' ],
                }                        
            }elsif $facts['os']['release']['major'] == '6' {
                exec { 'sudo rpm -Uvh https://packages.microsoft.com/config/rhel/6/packages-microsoft-prod.rpm': 
                    path => [ '/usr/bin', '/usr/sbin' ],
                }    
            }

            exec { 'sudo yum update -y': 
                path => [ '/usr/bin', '/usr/sbin' ],
            }         
        }
        default: {
            notify { "
            
                Unfortunally there's no configuration for your OS, but you can help us adding to https://github.com/daniloavilez/puppet-module-dotnetcore.

                We'll appreciate! :)
            
            ": } 
            
        }
    }

    package { "dotnet-sdk-${version}":
        ensure => installed,
    }
}