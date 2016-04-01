class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
  end

  def show
    @gram = Gram.find params[:id]
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

  private
  def gram_params
    params.require(:gram).permit(:message)
  end
end