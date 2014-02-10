class PostsController < ApplicationController
  before_filter :authenticate_user!
  
  expose_decorated(:posts) { Post.all }
  expose_decorated(:post, attributes: :post_params)
  expose(:tag_cloud) { Post.tags_with_weight }
  expose(:comments) do 
    if current_user.owner? post
      Comment.where({ post_id: post.id })
    else
     Comment.where({ post_id: post.id, abusive: false })
    end
  end

  helper_method :post_owner?

  def index
  end

  def new
  end

  def edit
  end

  def update
    if post.save
      render action: :index
    else
      render :new
    end
  end

  def destroy
    post.destroy if current_user.owner? post
    render action: :index
  end

  def show
  end

  def mark_archived
    # post = Post.find params[:id]
    post.archive!
    render action: :index
  end

  def create
    post.user = current_user
    if post.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def post_owner?
    current_user.owner? post
  end

  private
  def post_params
    return if %w{mark_archived}.include? action_name
    params.require(:post).permit(:body, :title, :tags)
  end
end
