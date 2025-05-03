require 'rails_helper'

RSpec.describe "Clients API", type: :request do
  let!(:user) { create(:user) }
  let(:headers) do
    {
      "Authorization" => "Bearer #{User.generate_token(user)}",
      "Content-Type" => "application/json"
    }
  end

  describe "GET /clients" do
    let!(:client1) { create(:client, name: "Alice", email: "alice@example.com") }
    let!(:client2) { create(:client, name: "Bob", email: "bob@example.com") }

    it "returns all clients" do
      get "/clients", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(2)
    end

    it "filters by name" do
      get "/clients", params: { name: "Alice" }, headers: headers
      json = JSON.parse(response.body)
      expect(json.first["name"]).to eq("Alice")
    end

    it "returns 401 if no token" do
      get "/clients"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /clients" do
    let(:valid_params) do
      { name: "New Client", email: "new@example.com" }.to_json
    end

    it "creates a client" do
      post "/clients", params: valid_params, headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("New Client")
    end

    it "fails with missing params" do
      post "/clients", params: { client: { name: "" } }.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:bad_request)
    end
  end

  describe "PATCH /clients/:id" do
    let!(:client) { create(:client, name: "Old", email: "old@example.com") }

    it "updates client" do
      patch "/clients/#{client.id}", params: { client: { name: "Updated" } }.to_json, headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("Updated")
    end

    it "returns not found for invalid ID" do
      patch "/clients/99999", params: { client: { name: "Updated" } }.to_json, headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /clients/:id" do
    let!(:client) { create(:client) }

    it "deletes client" do
      delete "/clients/#{client.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end

    it "returns not found if client does not exist" do
      delete "/clients/99999", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
