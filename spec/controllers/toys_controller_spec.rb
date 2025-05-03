require 'rails_helper'

RSpec.describe ToysController, type: :request do
  let!(:user) { create(:user) }
  let!(:token) { User.generate_token(user) }
  let(:headers) do
    {
      "Authorization" => "Bearer #{User.generate_token(user)}",
      "Content-Type" => "application/json"
    }
  end

  describe "GET /toys" do
    let!(:toy1) { create(:toy, name: "Car", value: 10.5) }
    let!(:toy2) { create(:toy, name: "Truck", value: 20.0) }

    it "returns all toys" do
      get "/toys", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe "POST /toys" do
    let(:valid_params) do
      { name: "New Toy", value: "15" }.to_json
    end

    it "creates a toy" do
      post "/toys", params: valid_params, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("New Toy")
    end

    it "returns error when name is missing" do
      post "/toys", params: { value: "10.0" }.to_json, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "PATCH /toys/:id" do
    let!(:toy) { create(:toy, name: "Old Toy") }

    it "updates a toy" do
      patch "/toys/#{toy.id}", params: { name: "New Toy" }.to_json, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("New Toy")
    end

    it "returns not found for invalid id" do
      patch "/toys/999", params: { name: "Ghost" }.to_json, headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /toys/:id" do
    let!(:toy) { create(:toy) }

    it "deletes a toy" do
      delete "/toys/#{toy.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end

    it "returns not found for invalid id" do
      delete "/toys/999", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
