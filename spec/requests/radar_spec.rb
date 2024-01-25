require 'rails_helper'

RSpec.describe "Radars", type: :request do
  describe "POST /radar" do
    it "returns http success" do
      post "/radar/", params: {criteria: "closest", editions: [] } 
      expect(response).to have_http_status(:success)
    end

    it "returns http missing due bad or lack of params" do
      post "/radar/", params: {criteria: "closest"}
      expect(response).to have_http_status(:missing)
    end

  end
  

end
