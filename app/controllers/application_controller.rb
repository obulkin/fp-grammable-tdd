class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :store_location

  # Store the previous URL as a user browses around and redirect to it after a sign in or sign up
  private
  def store_location
    session[:previous_path] = request.fullpath unless request.fullpath.include?("/users") || !request.get?
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:previous_path] || root_path
  end

  def after_sign_up_path_for(resource_or_scope)
    session[:previous_path] || root_path
  end
end