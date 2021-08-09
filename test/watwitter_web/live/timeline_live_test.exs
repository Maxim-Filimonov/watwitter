defmodule WatwitterWeb.TimelineLiveTest do
  use WatwitterWeb.ConnCase

  import Phoenix.LiveViewTest
  import Watwitter.Factory
  alias Watwitter.Timeline

  alias Watwitter.Timeline

  setup :register_and_log_in_user

  test "user can visit home page", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")

    assert html =~ "Home"
    assert render(view) =~ "Home"
  end

  test "current user can see own avatar", %{conn: conn, user: user} do
    {:ok, view, _html} = live(conn, "/")

    avatar = element(view, "img[src*=#{user.avatar_url}]")

    assert has_element?(avatar)
  end

  test "renders a list of posts", %{conn: conn} do
    [post1, post2] = insert_pair(:post)
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#post-#{post1.id}")
    assert has_element?(view, "#post-#{post2.id}")
  end

  test "shows posts when clicked", %{conn: conn} do
    post = insert(:post)
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("#post-#{post.id} [data-role=\"select-post\"]", post.body)
    |> render_click()

    assert view
           |> element("#show-post-#{post.id}")
           |> has_element?()
  end

  test "user can visit highlighted post url", %{conn: conn} do
    post = insert(:post)
    {:ok, view, _html} = live(conn, Routes.timeline_path(conn, :index, post_id: post.id))

    assert view
           |> element("#show-post-#{post.id}")
           |> has_element?()
  end

  test "user can visit settings page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    {:ok, conn} =
      view
      |> element("#user-avatar")
      |> render_click()
      |> follow_redirect(conn, Routes.user_settings_path(conn, :edit))

    assert html_response(conn, 200) =~ "Settings"
  end

  test "user can compose a new tweet", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    {:ok, view, _html} =
      view
      |> element("#compose-tweet")
      |> render_click()
      |> follow_redirect(conn, Routes.compose_path(conn, :new))

    assert view |> render() =~ "Compose Watweet"
  end

  test "users gets notified when posts are added(direct)", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    send(view.pid, {:post_created, insert(:post)})
    send(view.pid, {:post_created, insert(:post)})

    assert view |> has_element?("#new-posts-notice", "Show 2 posts")
  end

  test "users gets notified when posts are added(pubsub)", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    [post1, post2] = insert_pair(:post)

    Phoenix.PubSub.broadcast(Watwitter.PubSub, "timeline", {:post_created, post1})
    Phoenix.PubSub.broadcast(Watwitter.PubSub, "timeline", {:post_created, post2})

    assert view |> has_element?("#new-posts-notice", "Show 2 posts")
  end

  test "users gets notified when posts are added(call via domain function)", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    user = insert(:user)

    Timeline.create_post(params_for(:post, user: user))
    Timeline.create_post(params_for(:post, user: user))

    assert view |> has_element?("#new-posts-notice", "Show 2 posts")
  end

  test "users gets notified when posts are added", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    Timeline.broadcast_post_created(insert(:post))
    Timeline.broadcast_post_created(insert(:post))

    assert view |> has_element?("#new-posts-notice", "Show 2 posts")
  end

  test "user receives notification of new posts in timeline", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    [post1, post2] = insert_pair(:post)

    Timeline.broadcast_post_created(post1)
    Timeline.broadcast_post_created(post2)

    assert has_element?(view, "#new-posts-notice", "Show 2 posts")
  end

  test "user can see a new post", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    post = insert(:post)

    Timeline.broadcast_post_created(post)

    view
    |> element("#new-posts-notice", "Show 1 post")
    |> render_click()

    assert has_element?(view, "#post-#{post.id}")
    refute has_element?(view, "#new-posts-notice")
  end
end
