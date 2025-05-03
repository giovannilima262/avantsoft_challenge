require 'rails_helper'

RSpec.describe "SalesController", type: :request do
  let!(:user) { create(:user) }
  let!(:token) { User.generate_token(user) }
  let!(:headers) { 
    { 
      'Authorization' => "Bearer #{token}", 
      'Content-Type' => 'application/json'
    } 
  }

  let!(:client) { create(:client) }
  let!(:toy)    { create(:toy) }
  let!(:sale)   { create(:sale, client: client, toy: toy) }

  describe "GET /sales" do
    it "returns all sales" do
      get "/sales", headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["count"]).to eq(1)
      expect(body["sum_toy_values"]).to eq("19.99")
      expect(body["sales"].first["client"]["id"]).to eq(client.id)
    end
  end

  describe "POST /sales" do
    context "with valid parameters" do
      let(:valid_params) { { client_id: client.id, toy_id: toy.id }.to_json }

      it "creates a sale" do
        post "/sales", params: valid_params, headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["client"]["id"]).to eq(client.id)
        expect(body["toy"]["id"]).to eq(toy.id)
      end
    end

  end

  describe "PATCH /sales/:id" do
    it "updates a sale" do
      new_client = create(:client)
      patch "/sales/#{sale.id}", params: { sale: { client_id: new_client.id } }.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["client"]["id"]).to eq(new_client.id)
    end
  end

  describe "DELETE /sales/:id" do
    it "deletes the sale" do
      delete "/sales/#{sale.id}", headers: headers

      expect(response).to have_http_status(:no_content)
      expect(Sale.exists?(sale.id)).to be_falsey
    end
  end

  describe "GET /sales/higher/volume" do
    it "returns clients with higher volume" do
      get "/sales/higher/volume", headers: headers

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /sales/higher/average" do
    it "returns clients with highest average sale value" do
      get "/sales/higher/average", headers: headers

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /sales/higher/frequency" do
    it "returns clients with highest purchase frequency" do
      get "/sales/higher/frequency", headers: headers

      expect(response).to have_http_status(:ok)
    end
  end
end