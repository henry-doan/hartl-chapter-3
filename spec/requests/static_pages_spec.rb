require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "Home" do
    it "works! (now write some real specs)" do
     	get '/static_pages/home'
      expect(response).to have_http_status(200)
      expect(page).to have_css('h1', text: 'Home')
    end
  end

  describe "Help" do
    it "works! (now write some real specs)" do
     	get '/static_pages/help'
      expect(response).to have_http_status(200)
    end
  end
end
