require 'rails_helper'

RSpec.describe "Radars", type: :request do
  describe "POST /radar" do
    it "returns http success" do
      post "/radar/"
      expect(response).to have_http_status(:success)
    end
  end

end
