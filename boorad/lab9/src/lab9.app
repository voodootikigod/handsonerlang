{application, lab9,
 [{description, "lab9"},
  {vsn, "0.18"},
  {modules, [
    lab9,
    lab9_app,
    lab9_sup,
    lab9_deps,
    lab9_resource
  ]},
  {registered, []},
  {mod, {lab9_app, []}},
  {env, []},
  {applications, [kernel, stdlib, crypto]}]}.
