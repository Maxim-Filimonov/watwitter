defmodule WatwitterWeb.ComposeLive do
  use WatwitterWeb, :live_view

  alias Watwitter.Timeline
  alias Watwitter.Timeline.Post
  alias Watwitter.Accounts
  alias WatwitterWeb.SVGHelpers

  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    changeset = Timeline.change_post(%Post{})

    {:ok, assign(socket, changeset: changeset, current_user: current_user)}
  end

  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      Timeline.change_post(%Post{}, post_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event(
        "save",
        %{"post" => post_params},
        %{assigns: %{current_user: current_user}} = socket
      ) do
    params = Map.put(post_params, "user_id", current_user.id)

    case Timeline.create_post(params) do
      {:ok, _post} ->
        {:noreply, push_redirect(socket, to: Routes.timeline_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
