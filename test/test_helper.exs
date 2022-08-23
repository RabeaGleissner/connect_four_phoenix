ExUnit.start()
ExUnit.configure(exclude: :pending)

Ecto.Adapters.SQL.Sandbox.mode(ConnectGame.Repo, :manual)
