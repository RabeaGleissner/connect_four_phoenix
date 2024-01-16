defmodule ConnectGame.App.AiPlayer do
  alias ConnectGame.App.Rules

  def choose_column(moves, grid_height, random_number_generator) do
    random_column_index = random_number_generator.(0, grid_height)

    if Rules.column_has_space?(moves, random_column_index, grid_height) do
      random_column_index
    else
      choose_column(moves, grid_height, random_number_generator)
    end
  end
end
