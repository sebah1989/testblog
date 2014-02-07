class CommentsController < ApplicationController
  respond_to :html, :json, :js

	expose(:post)
  expose(:comment, attributes: :comment_params)
  expose(:comments, ancestor: :post) 
  expose(:vote_comment) { post.comments.find(params[:id]) }
  helper_method :post_owner?

  def new
  end

  def create
    if comment.save
      respond_with(post)
    end
  end

  def vote_up
    vote_comment.vote_up(current_user.id)
    respond_with(post)
  end

  def vote_down
    vote_comment.vote_down(current_user.id)
    respond_with(post)
  end

  def mark_as_not_abusive
    vote_comment.mark_as_not_abusive
    respond_with(post)
  end

  def post_owner?
    current_user.owner? post
  end
  
  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end