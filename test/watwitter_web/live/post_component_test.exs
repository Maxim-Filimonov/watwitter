defmodule WatwitterWeb.PostComponentTest do
  use WatwitterWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Watwitter.Factory

  alias Watwitter.Timeline.Like
  alias WatwitterWeb.PostComponent
  alias WatwitterWeb.DateHelpers

  doctest PostComponent

  test "renders post details" do
    post = insert(:post)

    html = render_component(PostComponent, post: post, current_user: insert(:user))

    assert html =~ post.body
    assert html =~ DateHelpers.format_short(post.inserted_at)
  end

  test "renders author details" do
    author = insert(:user)
    post = insert(:post, user: author)

    html = render_component(PostComponent, post: post, current_user: author)

    assert html =~ author.name
    assert html =~ "@#{author.username}"
    assert html =~ author.avatar_url
  end

  test "renders reposts button" do
    post = insert(:post, reposts_count: 333)

    html = render_component(PostComponent, post: post, current_user: insert(:user))

    assert html =~ "data-role=\"reposts-count\""
    assert html =~ "333"
  end

  test "renders like button and like count" do
    post = insert(:post, likes_count: 876)

    html = render_component(PostComponent, post: post, current_user: insert(:user))

    assert html =~ data_role("like-button")
    assert html =~ data_role("like-count")
    assert html =~ "876"
  end

  test "renders liked button when current user likes post" do
    current_user = insert(:user)
    post = insert(:post, likes: [%Like{user_id: current_user.id}])

    html = render_component(PostComponent, post: post, current_user: current_user)

    assert html =~ data_role("post-liked")
    refute html =~ data_role("like-button")
  end

  defp data_role(role), do: "data-role=\"#{role}\""
end
