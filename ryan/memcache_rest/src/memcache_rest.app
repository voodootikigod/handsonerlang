{application, memcache_rest,
 [{description, "memcache_rest"},
  {vsn, "0.18"},
  {modules, [
    memcache_rest,
    memcache_rest_app,
    memcache_rest_sup,
    memcache_rest_deps,
    memcache_rest_resource
  ]},
  {registered, []},
  {mod, {memcache_rest_app, []}},
  {env, []},
  {applications, [kernel, stdlib, crypto]}]}.
