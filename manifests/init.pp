# Class: auth_manager
#
#
class auth_manager (
  $users    = params_lookup('users'),
) inherits auth_manager::params {
  # resources
  notify { 'Creating users':
  }
  class { 'auth_manager::users':
    users => $users,
  }
}
