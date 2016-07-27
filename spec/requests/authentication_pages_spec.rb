require 'rails_helper'

RSpec.describe "AuthenticationPages", type: :request do
  describe "GET /authentication_pages" do
    it "works! (now write some real specs)" do
      get authentication_pages_index_path
      expect(response).to have_http_status(200)
    end
  end

  describe "Authentication" do

  	subject { page }

  	describe "signin page" do
  		before { visit signin_path }

  		it { should have_selector('h1', text: 'Sign in')}
  	end
  end
end
