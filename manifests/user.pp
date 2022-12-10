define auth_manager::user (
  $username = $title,
  $ensure='',
  $home='',
  $managehome=true,
  $home_mode='0700',
  $ssh_keys= {},
  $comment='',
  $groups= {},
  $password='',
  $shell='/bin/bash',
  $purge_ssh_keys=true,
) {
  User <| title == $username |> { managehome => true }
  User <| title == $username |> { home => "/home/${username}" }

  # Create user
  user { $username:
    ensure         => present,
    password       => $password,
    shell          => $shell,
    purge_ssh_keys => $purge_ssh_keys,
    comment        => $comment,
  }

  file { "/home/${username}":
    ensure => directory,
    owner  => $username,
    group  => $username,
    mode   => $home_mode,
  }

  file { "/home/${username}/.ssh":
    ensure => directory,
    owner  => $username,
    group  => $username,
    mode   => '0700',
  }

  file { "/home/${username}/.ssh/authorized_keys":
    owner   => $username,
    group   => $username,
    mode    => '0600',
    require => File["/home/${username}/.ssh"],
  }

  Ssh_authorized_key {
    require => File["/home/${username}/.ssh/authorized_keys"],
  }
  # template of creating ssh_authorized_key
  $ssh_key_defaults = {
    ensure  => present,
    user    => $username,
    type    => $ssh_keys['type'],
    key     => $ssh_keys['key'],
  }

  create_resources('ssh_authorized_key', $ssh_keys, $ssh_key_defaults)
}
