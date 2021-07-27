defmodule WatwitterWeb.PostComponent do
  use WatwitterWeb, :live_component
  alias WatwitterWeb.DateHelpers
  alias WatwitterWeb.SVGHelpers

  def render(assigns) do
    ~L"""
    <div id="post-<%= @post.id %>" class="post">
      <img class="avatar" src="<%= @post.user.avatar_url %>">
      <div class="post-content">
        <div class="post-header">
          <div class="post-user-info">
            <span class="post-user-name">
              <%= @post.user.name %>
            </span>
            <span class="post-user-username">
              @<%= @post.user.username %>
            </span>
          </div>

          <div class="post-date-info">
            <span class="post-date-separator">.</span>
            <span class="post-date">
              <%= DateHelpers.format_short(@post.inserted_at) %>
            </span>
          </div>
        </div>

        <div class="post-body">
          <%= @post.body %>
        </div>

        <div class="post-actions">
          <a class="post-action" href="#" data-role="likes-button">
            <%= SVGHelpers.like_svg() %>
            <span class="post-action-likes" data-role="likes-count">
              <%= @post.likes_count %>
            </span>
          </a>
          <a class="post-action" href="#" data-role="reposts-button">
            <%= SVGHelpers.repost_svg() %>
            <span class="post-action-likes" data-role="reposts-count">
              <%= @post.reposts_count %>
            </span>
          </a>
        </div>
      </div>
    </div>
    """
  end
end
