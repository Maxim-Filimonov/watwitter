defmodule WatwitterWeb.TimelineLive do
  use WatwitterWeb, :live_view

  alias Watwitter.{Accounts, Timeline}
  alias WatwitterWeb.{PostComponent, ShowPostComponent}
  alias WatwitterWeb.SVGHelpers

  def mount(_params, session, socket) do
    if connected?(socket) do
      Timeline.subscribe()
    end

    current_user = Accounts.get_user_by_session_token(session["user_token"])
    posts = Timeline.list_posts()

    {:ok,
     assign(socket,
       posts: posts,
       current_user: current_user,
       current_post: nil,
       new_posts_count: 0
     )}
  end

  def handle_params(%{"post_id" => post_id}, _, socket) do
    id = String.to_integer(post_id)
    current_post = Enum.find(socket.assigns.posts, &(&1.id == id))
    {:noreply, assign(socket, current_post: current_post)}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  def handle_info({:post_created, _post}, socket) do
    {:noreply, update(socket, :new_posts_count, &(&1 + 1))}
  end
end
