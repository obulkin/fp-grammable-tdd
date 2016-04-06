class GramsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_for_gram_owner, only: [:edit, :update, :destroy]

  def index
    @grams = Gram.all
  end

  def show
    @gram = Gram.find params[:id]
    @comment = Comment.new
    @gram_comments = @gram.comments
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = Gram.new gram_params.merge(user_id: current_user.id)
    if @gram.save
      redirect_to root_path
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    @gram = Gram.find params[:id]
  end

  def update
    @gram = Gram.find params[:id]
    if @gram.update_attributes gram_params
      redirect_to gram_path(@gram)
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    Gram.find(params[:id]).destroy
    redirect_to root_path
  end

  private
  def gram_params
    params.require(:gram).permit(:message, :image)
  end

  def check_for_gram_owner
    render text: "Forbidden: This can only be done by the creator of the gram.", status: :forbidden if current_user != Gram.find(params[:id]).user
  end
end