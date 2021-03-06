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
      it "should respond to a POST with valid data by creating a new gram with that data and redirecting to the homepage" do
        user = create :user
        sign_in user
        post :create, gram: {message: "Hello!", image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/sample.jpg", "image/jpeg")}
        expect(response).to redirect_to(root_path)

        gram = Gram.last
        expect(gram.message).to eq("Hello!")
        expect(gram.user).to eq(user)
        expect(gram.image_identifier).to eq("sample.jpg")
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

  describe "#edit" do
    context "when the gram owner is signed in" do
      it "should respond to a GET with a valid gram ID successfully" do
        gram = create :gram
        sign_in gram.user
        get :edit, id: gram.id
        expect(response).to have_http_status(:success)
      end
    end

    context "when a different user is signed in" do
      it "should respond to a GET with a valid gram ID by returning a 403" do
        gram = create :gram
        sign_in create(:user)
        get :edit, id: gram.id
        expect(response).to have_http_status(:forbidden)
      end

      it "should respond to a GET with an invalid gram ID by raising a RecordNotFound error" do
        sign_in create(:user)
        expect{get :edit, id: "invalid_id"}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when no one is signed in" do
      it "should respond to a GET by redirecting to the sign in page" do
        gram = create :gram
        get :edit, id: gram.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#update" do
    context "when the gram owner is signed in" do
      it "should respond to a PUT with a valid gram ID and a validation error by returning a 422 and not updating the gram" do
        gram = create :gram, message: "Original Message"
        sign_in gram.user
        put :update, id: gram.id, gram: {message: ""}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(gram.message).to eq("Original Message")
      end

      it "should respond to a PUT with a valid gram ID and valid data by updating the gram with that data and redirecting to its show page" do
        gram = create :gram, message: "Original Message"
        sign_in gram.user
        put :update, id: gram.id, gram: {message: "New Message"}
        expect(response).to redirect_to(gram_path gram)

        gram.reload
        expect(gram.message).to eq("New Message")
      end
    end

    context "when a different user is signed in" do
      it "should respond to a PUT with a valid gram ID and any data by returning a 403 and not updating the gram" do
        gram = create :gram, message: "Original Message"
        sign_in create(:user)
        put :update, id: gram.id, gram: {message: "New Message"}
        expect(response).to have_http_status(:forbidden)
        expect(gram.message).to eq("Original Message")
      end

      it "should respond to a PUT with an invalid gram ID by raising a RecordNotFound error" do
        sign_in create(:user)
        expect{put :update, id: "invalid_id"}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when no one is signed in" do
      it "should respond to a PUT by redirecting to the sign in page" do
        gram = create :gram
        put :update, id: gram.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end 
  end

  describe "#destroy" do
    context "when the gram owner is signed in" do
      it "should respond to a DELETE with a valid gram ID by deleting the gram and its comments and redirecting to the homepage" do
        gram = create :gram_with_comments
        comments = gram.comments
        sign_in gram.user
        delete :destroy, id: gram.id
        expect(response).to redirect_to(root_path)
        expect{gram.reload}.to raise_error(ActiveRecord::RecordNotFound)
        expect(comments.reload.present?).to eq(false)
      end
    end

    context "when a different user is signed in" do
      it "should respond to a DELETE with a valid gram ID by returning a 403 and not deleting the gram" do
        gram = create :gram
        sign_in create(:user)
        delete :destroy, id: gram.id
        expect(response).to have_http_status(:forbidden)
        expect{gram.reload}.not_to raise_error
      end

      it "should respond to a DELETE with an invalid gram ID by raising a RecordNotFound error" do
        sign_in create(:user)      
        expect{delete :destroy, id: "invalid_id"}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when no one is signed in" do
      it "should respond to a PUT by redirecting to the sign in page" do
        gram = create :gram
        put :update, id: gram.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end