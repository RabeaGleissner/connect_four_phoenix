defmodule ConnectGameWeb.Helpers.RandomNumber do
  def generate_between(first_number, last_number) do
    first_number..last_number |> Enum.random()
  end
end
