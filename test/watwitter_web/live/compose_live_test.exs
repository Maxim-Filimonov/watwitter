defmodule WatwitterWeb.ComposeLiveTest do
  use WatwitterWeb.ConnCase, async: true
  alias WatwitterWeb.ComposeLive

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user
  doctest ComposeLive

  test "user can compose new post", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.compose_path(conn, :new))

    {:ok, _view, html} =
      view
      |> form("#new-post", post: %{body: "A post from the test"})
      |> render_submit()
      |> follow_redirect(conn)

    assert html =~ "A post from the test"
  end

  test "user is notified when posting failed", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.compose_path(conn, :new))

    rendered =
      view
      |> form("#new-post", post: %{body: nil})
      |> render_submit()

    assert rendered =~ "can&apos;t be blank"
  end
end
