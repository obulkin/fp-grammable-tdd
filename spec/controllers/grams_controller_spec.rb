require 'rails_helper'

RSpec.describe GramsController, :type => :controller do
  describe "#index" do
    it "should respond to a GET successfully" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "#new" do
    it "should respond to a GET successfully" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "#create" do
    it "should respond to a POST with a message by creating a new gram with that message and redirecting to the homepage" do
      post :create, gram: {message: "Hello!"}
      expect(response).to redirect_to(root_path)

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
    end
  end
end