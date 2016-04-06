class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @gram = Gram.find params[:gram_id]
    @comment = Comment.new comment_params.merge(user_id: current_user.id, gram_id: @gram.id)
    if @comment.save
      redirect_to gram_path(@gram)
    else
      @gram_comments = @gram.comments
      render "grams/show", status: :unprocessable_entity
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:message)
  end
end