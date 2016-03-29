require 'rails_helper'

RSpec.describe GramsController, :type => :controller do
  describe "#index" do
    it "should respond to a GET successfully" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end