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

  test "renders like button" do
    post = insert(:post, likes_count: 275)

    html = render_component(PostComponent, post: post)

    assert html =~ "data-role=\"likes-button\""
    assert html =~ "data-role=\"likes-count\""
    assert html =~ "275"
  end

  test "renders reposts button" do
    post = insert(:post, reposts_count: 333)

    html = render_component(PostComponent, post: post)

    assert html =~ "data-role=\"reposts-button\""
    assert html =~ "data-role=\"reposts-count\""
    assert html =~ "333"
  end

  test "renders reposts button" do
    post = insert(:post, reposts_count: 333)

    html = render_component(PostComponent, post: post)

    assert html =~ "data-role=\"reposts-button\""
    assert html =~ "data-role=\"reposts-count\""
    assert html =~ "333"
  end
end
