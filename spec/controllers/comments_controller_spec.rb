require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "#create" do
    context "when no one is signed in" do
      it "should respond to a POST by redirecting to the sign in page" do
        post :create, gram_id: "irrelevant"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when a user is signed in" do
      it "should respond to a POST with an invalid gram ID by raising a RecordNotFound error" do
        sign_in create(:user)
        expect{post :create, gram_id: "invalid_id"}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should respond to a POST with a valid gram ID and a validation error by returning a 422 and not creating a comment" do
        sign_in create(:user)
        gram = create :gram
        post :create, gram_id: gram.id, comment: {message: ""}
        expect(response).to have_http_status(:unprocessable_entity)

        gram.reload
        expect(gram.comments.count).to eq(0)
      end

      it "should respond to a POST with a valid gram ID and valid data by creating a comment with the data and redirecting to the gram page" do
        user = create :user
        gram = create :gram
        sign_in user
        post :create, gram_id: gram.id, comment: {message: "The best comment"}
        expect(response).to redirect_to(gram_path gram)

        gram.reload
        expect(gram.comments.first.message).to eq("The best comment")
        expect(gram.comments.first.user).to eq(user)
      end
    end
  end
end