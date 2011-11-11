class PagesController < ApplicationController

  def home
    @posts = Post.published.order("created_at DESC").limit(5)
  end

  def clients
  end

end
