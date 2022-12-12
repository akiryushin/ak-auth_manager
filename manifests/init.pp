# Class: auth_manager
#
#
class auth_manager (
  $users    = $auth_manager::params::users,
) inherits auth_manager::params {
  # resources
  notify { 'Managing users':
  }
  class { 'auth_manager::users':
    users => $users,
  }
}
