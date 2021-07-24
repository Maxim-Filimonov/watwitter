defmodule WatwitterWeb.TimelineLiveTest do
  use WatwitterWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  test "user can visit home page", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    assert html =~ "Home"
  end
end
