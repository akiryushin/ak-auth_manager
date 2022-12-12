class auth_manager::users (
  $users,
) {
  # Initial global users Hash
  $global_users = hiera_hash('global::users')

  # notify { 'global_users':
  #   message => $global_users,
  # }

  # get users from current context
  $user_data = $users.filter |$user, $params| { !defined(User[$user]) }

  # notify { 'user_data':
  #   message => $user_data,
  # }

  # get user data from global dictionary
  $global_user_data = $global_users.filter |$user, $params| { $user in $user_data }

  # notify { 'global_user_data':
  #   message => $global_user_data,
  # }

  # merge global and user data
  $resulted_params = $user_data.map |$user, $params| {
    [$user, merge($global_user_data[$user], $params)]
  }.hash()

  # notify { 'resulted_params':
  #   message => $resulted_params,
  # }

  create_resources(auth_manager::user, $resulted_params)
}
