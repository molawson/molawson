class PagesController < ApplicationController

  def home
    @posts = Post.published.order("created_at DESC").limit(5)
    @post_days = @posts.group_by { |post| post.created_at.beginning_of_day }
  end

end
