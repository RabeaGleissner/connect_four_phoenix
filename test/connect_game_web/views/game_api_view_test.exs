defmodule ConnectGameWeb.GameApiViewTest do
  use ConnectGameWeb.ConnCase, async: true

  alias ConnectGameWeb.GameApiView
  alias ConnectGame.App.Game
  alias ConnectGame.App.Move

  test "returns json data for a game" do
    game = %Game{
      id: "1",
      winner: nil,
      ended: false,
      draw: false,
      current_player: "red",
      moves: [
        %Move{
          id: "9",
          y_coordinate: 1,
          x_coordinate: 2,
          player: "yellow"
        }
      ]
    }

    json = GameApiView.render("show.json", game: game)

    assert json == %{
             data: %{
               id: "1",
               winner: nil,
               ended: false,
               connect_what: 4,
               grid_height: 6,
               grid_width: 7,
               moves: [%{id: "9", y_coordinate: 1, x_coordinate: 2, player: "yellow"}],
               draw: false,
               current_player: "red"
             }
           }
  end
end
