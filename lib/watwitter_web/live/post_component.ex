defmodule WatwitterWeb.PostComponent do
  use WatwitterWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
      <div id="post-<%= @post.id %>"/>
    """
  end
end
