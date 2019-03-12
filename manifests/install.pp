# Class: netcore::install
#
#
class netcore::install(
    $version = '2.2',
) {

    case $facts['os']['family'] {
        'Debian': {
            if $facts['os']['release']['major'] == '14.04' {
                exec { 'wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb': 
                    path => [ '/usr/bin', '/usr/sbin' ],
                }
            }

            exec { 'sudo dpkg -i packages-microsoft-prod.deb': 
                path => [ '/usr/bin', '/usr/sbin' ],
            }

            package { 'apt-transport-https':
                ensure => installed,
            }

            exec { 'sudo apt-get update': 
                path => [ '/usr/bin', '/usr/sbin' ],
            }
        }
        'RedHat': {
            if $facts['os']['release']['major'] == '7' {
                exec { 'sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm': 
                    path => [ '/usr/bin', '/usr/sbin' ],
                }                        
            }

            exec { 'sudo yum update -y': 
                path => [ '/usr/bin', '/usr/sbin' ],
            }         
        }
        default: {
            # code
        }
    }

    package { "dotnet-sdk-${version}":
        ensure => installed,
    }
}