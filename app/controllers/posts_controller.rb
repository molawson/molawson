class PostsController < ApplicationController
  
  def blog
    @posts = Post.published.order("created_at DESC")
  end
  
  def show
    @post = Post.published.find_by_slug(params[:slug])
  end
  
  def index
    @posts = Post.order("created_at DESC")
  end

  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to posts_path, :notice => "Successfully created '#{@post.title}'"
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to posts_path, :notice => "Successfully updated '#{@post.title}'"
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, :notice => "Successfully deleted '#{@post.title}'"
  end

end
