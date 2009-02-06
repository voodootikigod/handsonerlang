{application, user_management,
 [{description, "user_management"},
  {vsn, "0.18"},
  {modules, [
    user_management,
    user_management_app,
    user_management_sup,
    user_management_deps,
    user_management_resource
  ]},
  {registered, []},
  {mod, {user_management_app, []}},
  {env, []},
  {applications, [kernel, stdlib, crypto]}]}.
