defmodule ConnectGame.Repo do
  use Ecto.Repo,
    otp_app: :connect_game,
    adapter: Ecto.Adapters.Postgres
end
