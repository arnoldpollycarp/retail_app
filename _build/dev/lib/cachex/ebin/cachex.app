{application,cachex,
             [{applications,[kernel,stdlib,elixir,logger,eternal]},
              {description,"Powerful in-memory key/value storage for Elixir"},
              {modules,['Elixir.Cachex','Elixir.Cachex.Actions',
                        'Elixir.Cachex.Actions.Clear',
                        'Elixir.Cachex.Actions.Count',
                        'Elixir.Cachex.Actions.Del',
                        'Elixir.Cachex.Actions.Dump',
                        'Elixir.Cachex.Actions.Empty',
                        'Elixir.Cachex.Actions.Exists',
                        'Elixir.Cachex.Actions.Expire',
                        'Elixir.Cachex.Actions.Get',
                        'Elixir.Cachex.Actions.GetAndUpdate',
                        'Elixir.Cachex.Actions.Incr',
                        'Elixir.Cachex.Actions.Inspect',
                        'Elixir.Cachex.Actions.Invoke',
                        'Elixir.Cachex.Actions.Keys',
                        'Elixir.Cachex.Actions.Load',
                        'Elixir.Cachex.Actions.Purge',
                        'Elixir.Cachex.Actions.Refresh',
                        'Elixir.Cachex.Actions.Reset',
                        'Elixir.Cachex.Actions.Set',
                        'Elixir.Cachex.Actions.Size',
                        'Elixir.Cachex.Actions.Stats',
                        'Elixir.Cachex.Actions.Stream',
                        'Elixir.Cachex.Actions.Take',
                        'Elixir.Cachex.Actions.Touch',
                        'Elixir.Cachex.Actions.Transaction',
                        'Elixir.Cachex.Actions.Ttl',
                        'Elixir.Cachex.Actions.Update',
                        'Elixir.Cachex.Application','Elixir.Cachex.Commands',
                        'Elixir.Cachex.Constants','Elixir.Cachex.Disk',
                        'Elixir.Cachex.Errors','Elixir.Cachex.ExecutionError',
                        'Elixir.Cachex.Fallback','Elixir.Cachex.Hook',
                        'Elixir.Cachex.Hook.Behaviour',
                        'Elixir.Cachex.Hook.Stats','Elixir.Cachex.Janitor',
                        'Elixir.Cachex.Limit','Elixir.Cachex.LockManager',
                        'Elixir.Cachex.LockManager.Server',
                        'Elixir.Cachex.LockManager.Table',
                        'Elixir.Cachex.Macros','Elixir.Cachex.Options',
                        'Elixir.Cachex.Policy','Elixir.Cachex.Policy.LRW',
                        'Elixir.Cachex.Record','Elixir.Cachex.State',
                        'Elixir.Cachex.Stats','Elixir.Cachex.Util',
                        'Elixir.Cachex.Util.Names']},
              {registered,[]},
              {vsn,"2.1.0"},
              {mod,{'Elixir.Cachex.Application',[]}}]}.