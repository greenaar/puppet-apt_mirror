apt-mirror puppet module
========================
A simple Puppet module for apt-mirror.

Usage
-----
```puppet
class apt_mirror (
  ensure                    => present,
  enabled                   => true,
  base_path                 => '/var/spool/apt-mirror',
  defaultarch               => $::architecture,
  run_postmirror            => 0,
  nthreads                  => 5,
  tilde                     => 0,
  wget_limit_rate           => undef,
  wget_auth_no_challenge    => false,
  wget_no_check_certificate => false,
  wget_unlink               => false,
  cron_hour                 => '4,16',
  cron_minute               => '15',
  apt_user                  => 'apt-mirror',
}

apt_mirror::mirror { 'puppetlabs':
  mirror      => 'apt.puppetlabs.com',
  release     => [
                  'precise',
                  'trusty'
                 ],
  path        => 'apt',
  components  => [
                   'main',
                   'contrib',
                   'non-free'
                 ],
  source      => false,
  amd64       => false,
  i386        => false,
  armhf       => false,
  protocol    => 'http',
}
```

