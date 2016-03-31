class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
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

  private
  def gram_params
    params.require(:gram).permit(:message)
  end
end