# apt_mirror::mirror
#
# mirror - The URL of the repository to mirror.
# release - An array of apt repository distributions to mirror.
# components - An array of apt repository components to mirror.
# amd64 - Set to true to enable mirroring of the amd64 packages. Defaults to false.
# i386 - Set to true to enable mirroring of the i386 packages. Defaults to false.
# source - Set to true to enable mirroring of the dpkg source files. Defaults to false.
# armhf - Set to true to enable mirroring ARM specific files, defaults to false.
# protocol - the protocol (http or https) to use
# path - the URI from / to reference

define apt_mirror::mirror (
  $mirror,
  $path       = 'apt',
  $release    = ['precise'],
  $components = ['main', 'contrib', 'non-free'],
  $source     = false,
  $amd64      = false,
  $i386       = false,
  $armhf      = false,
  $protocol   = 'http',
) {

  $aptmirror=$::osfamily ? {
    'RedHat'          => '/etc/apt-mirror.list',
    'Debian'          => '/etc/apt/mirror.list',
    default           => '/etc/apt/mirror.list',
  }

  concat::fragment { $name:
    target  => $aptmirror,
    content => template('apt_mirror/mirror.erb'),
    order   => '02',
  }

}
