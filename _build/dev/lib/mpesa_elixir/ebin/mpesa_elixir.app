{application,mpesa_elixir,
             [{applications,[kernel,stdlib,elixir,logger,httpotion,timex,
                             poison,rsa,ex_crypto]},
              {description,"  Elixir wrapper for Safricom Mpesa API\n"},
              {modules,['Elixir.Account','Elixir.MpesaElixir',
                        'Elixir.MpesaElixir.Auth','Elixir.MpesaElixir.B2b',
                        'Elixir.MpesaElixir.B2c','Elixir.MpesaElixir.C2b',
                        'Elixir.MpesaElixir.PublicKey',
                        'Elixir.MpesaElixir.PublicKey.Record',
                        'Elixir.MpesaElixir.StkPush',
                        'Elixir.MpesaElixir.Transaction']},
              {registered,[]},
              {vsn,"0.1.1"}]}.