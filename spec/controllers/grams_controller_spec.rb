require 'rails_helper'

RSpec.describe GramsController, :type => :controller do
  describe "#index" do
    it "should respond to a GET successfully" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "#show" do
    it "should respond to a GET with a valid gram ID successfully" do
      gram = create :gram
      get :show, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should respond to a GET with an invalid gram ID by raising a RecordNotFound error" do
      expect{get :show, id: "invalid_id"}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#new" do
    context "when a user is signed in" do 
      it "should respond to a GET successfully" do
        sign_in create(:user)
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    context "when no one is signed in" do
      it "should respond to a GET by redirecting to the sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#create" do
    context "when a user is signed in" do
      it "should respond to a POST with a message by creating a new gram with that message and redirecting to the homepage" do
        user = create :user
        sign_in user
        post :create, gram: {message: "Hello!"}
        expect(response).to redirect_to(root_path)

        gram = Gram.last
        expect(gram.message).to eq("Hello!")
        expect(gram.user).to eq(user)
      end

      it "should respond to a POST with a validation error by returning a 422 and not creating a new gram" do
        sign_in create(:user)
        post :create, gram: {message: ""}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(Gram.count).to eq(0)
      end
    end

    context "when no one is signed in" do
      it "should respond to a POST by redirecting to the sign in page" do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end