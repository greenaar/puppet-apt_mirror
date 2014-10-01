# = Class: apt_mirror
#
# Configures apt-mirror main configuration
#
# == Parameters
#
# [*ensure*] Default: present
# The ensure value for apt-mirror package.
#
# [*enabled*] Default: true
# Enables/disables cron job.
#
# [*base_path*] Default: /var/spool/apt-mirror
# The base directory for apt-mirror.
#
# [*var_path*] Default: $base_path/var
# Directory where apt-mirror logs.
#
# [*defaultarch*] Default: $::architecture
# Architectures to be mirrored.
#
# [*cleanscript*] Default: $var_path/clean.sh
# Script to be executed for cleaning up.
#
# [*postmirror_script*] Default: $var_path/postmirror.sh
# Script to be executed for post mirroring tasks.
#
# [*run_postmirror*] Default: 0
# Whether to execute postmirror script.
#
# [*nthreads*] Default: 20
# Number of threads to be run in parallel.
#
# [*tilde*] Default: 0
# Allow proper download of mirrors with a tilde in the url or package name.
#
# [*wget_limit_rate*] Default: undef (unlimited)
# Limit bandwidth for wget/thread.
#
# [*wget_auth_no_challenge*] Default: false
# Wget will send Basic HTTP authentication information (plaintext username
# and password) for all requests.
#
# [*wget_no_check_certificates*] Default: false
# Don't check validate the ssl certificate, required for self-signed targets
#
# [*wget_unlink*] Default: false
# Force wget to unlink file instead of clobbering existing file.
#
#
class apt_mirror (
  $ensure                    = present,
  $enabled                   = true,
  $base_path                 = '/var/spool/apt-mirror',
  $mirror_path               = '$base_path/mirror',
  $var_path                  = '$base_path/var',
  $defaultarch               = $::architecture,
  $cleanscript               = '$var_path/clean.sh',
  $postmirror_script         = '$var_path/postmirror.sh',
  $run_postmirror            = 0,
  $nthreads                  = 5,
  $tilde                     = 0,
  $wget_limit_rate           = undef,
  $wget_auth_no_challenge    = false,
  $wget_no_check_certificate = false,
  $wget_unlink               = false,
  $cron_hour                 = '4,16',
  $cron_minute               = '15',
  $apt_user                  = 'apt-mirror',
) {

  $aptmirror=$::osfamily ? {
    'RedHat'          => '/etc/apt-mirror.list',
    'Debian'          => '/etc/apt/mirror.list',
    default           => '/etc/apt/mirror.list',
  }

  package { 'apt-mirror':
    ensure => $ensure,
  }

  concat { $aptmirror:
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  concat::fragment { 'mirror.list header':
    target  => $aptmirror,
    content => template('apt_mirror/header.erb'),
    order   => '01',
  }

  file { '/etc/cron.d/apt-mirror':
    ensure  => $ensure,
    content => template('apt_mirror/cron.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
