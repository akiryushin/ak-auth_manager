class auth_manager::users (
  $users,
) {
  create_resources(auth_manager::user, $users)
}
