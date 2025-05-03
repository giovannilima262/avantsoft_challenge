require 'rails_helper'

RSpec.describe SalesService do
  include ActiveSupport::Testing::TimeHelpers

  let!(:client1) { create(:client) }
  let!(:client2) { create(:client) }
  let!(:toy1) { create(:toy, value: 10.0) }
  let!(:toy2) { create(:toy, value: 20.0) }

  describe ".get_sales_by_date" do
    before do
      travel_to Time.zone.parse("2023-01-01 10:00:00") do
        create(:sale, client: client1, toy: toy1)
        create(:sale, client: client1, toy: toy2)
      end
      create(:sale, client: client2, toy: toy1, created_at: "2023-02-01")
    end

    it "returns sales for a specific date" do
      result = SalesService.get_sales_by_date("2023-01-01")

      expect(result[:count]).to eq(2)
      expect(result[:sum_toy_values]).to eq(30.0)
      expect(result[:sales].as_json.size).to eq(2)
    end

    it "returns all sales if no date is given" do
      result = SalesService.get_sales_by_date(nil)

      expect(result[:count]).to eq(3)
      expect(result[:sum_toy_values]).to eq(40.0)
    end
  end

  describe ".get_higher_volume" do
    before do
      create_list(:sale, 5, client: client1, toy: toy1)
      create_list(:sale, 2, client: client2, toy: toy1)
    end

    it "returns the client with the most sales" do
      result = SalesService.get_higher_volume

      expect(result[:total_sales]).to eq(5)
      expect(result[:client].id).to eq(client1.id)
    end
  end

  describe ".get_highest_average_amount" do
    before do
      create(:sale, client: client1, toy: toy1)
      create(:sale, client: client1, toy: toy2)
      create(:sale, client: client2, toy: toy1)
    end

    it "returns the client with the highest average toy value" do
      result = SalesService.get_highest_average_amount

      expect(result[:client].id).to eq(client1.id)
      expect(result[:average_value]).to eq(15.0)
    end
  end

  describe ".get_highest_frequency" do
    before do
      create(:sale, client: client1, toy: toy1, created_at: "2023-01-01")
      create(:sale, client: client1, toy: toy1, created_at: "2023-01-02")
      create(:sale, client: client2, toy: toy1, created_at: "2023-01-01")
    end

    it "returns the client who purchased on the most unique days" do
      result = SalesService.get_highest_frequency

      expect(result[:unique_days_of_purchase]).to eq(2)
      expect(result[:client].id).to eq(client1.id)
    end
  end
end
