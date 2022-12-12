define auth_manager::user (
  $username = $title,
  $ensure=present,
  $home="/home/${username}",
  $managehome=true,
  $home_mode='0700',
  $ssh_keys= {},
  $comment='',
  $groups=undef,
  $password='',
  $shell='/bin/bash',
  $purge_ssh_keys=true,
) {
  notify { $username:
    message => $ensure,
  }

  User <| title == $username |> { managehome => true }
  User <| title == $username |> { home => $home }

  # Create user
  user { $username:
    ensure         => $ensure,
    password       => $password,
    shell          => $shell,
    groups         => $groups,
    purge_ssh_keys => $purge_ssh_keys,
    comment        => $comment,
  }

  file { $home:
    ensure => $ensure ? { 'absent' => absent, default => 'directory' },
    owner  => $username,
    group  => $username,
    mode   => $home_mode,
  }

  file { "${home}/.ssh":
    ensure  => $ensure ? { 'absent' => absent, default => 'directory' },
    owner   => $username,
    group   => $username,
    mode    => '0700',
    require => File[$home],
  }

  file { "${home}/.ssh/authorized_keys":
    ensure  => $ensure,
    owner   => $username,
    group   => $username,
    mode    => '0600',
    require => File["${home}/.ssh"],
  }
  if $ssh_keys {
    Ssh_authorized_key {
      require => File["${home}/.ssh/authorized_keys"],
    }
    # template of creating ssh_authorized_key
    $ssh_key_defaults = {
      ensure  => $ensure,
      user    => $username,
      type    => $ssh_keys['type'],
      key     => $ssh_keys['key'],
    }

    create_resources('ssh_authorized_key', $ssh_keys, $ssh_key_defaults)
  }
}
