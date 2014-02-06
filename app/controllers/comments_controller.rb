class CommentsController < ApplicationController
	expose(:post)
  expose(:comment, attributes: :comment_params)
  expose(:comments, ancestor: :post) 
  expose(:vote_comment) { post.comments.find(params[:id]) }

  def new
  end

  def create
    if comment.save
      redirect_to post_path(post)
    end
  end

  def vote_up
    vote_comment.vote_up(current_user.id)
    redirect_to post
  end

  def vote_down
    vote_comment.vote_down(current_user.id)
    redirect_to post
  end

  def mark_as_not_abusive
    vote_comment.mark_as_not_abusive
    redirect_to post
  end
  
  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end