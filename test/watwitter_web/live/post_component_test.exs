defmodule WatwitterWeb.PostComponentTest do
  use WatwitterWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Watwitter.Factory

  alias WatwitterWeb.PostComponent
  alias WatwitterWeb.DateHelpers

  doctest PostComponent

  test "renders post details" do
    post = insert(:post)

    html = render_component(PostComponent, post: post)

    assert html =~ post.body
    assert html =~ DateHelpers.format_short(post.inserted_at)
  end

  test "renders author details" do
    author = insert(:user)
    post = insert(:post, user: author)

    html = render_component(PostComponent, post: post)

    assert html =~ author.name
    assert html =~ "@#{author.username}"
    assert html =~ author.avatar_url
  end
end
