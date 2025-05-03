class SalesService
  def self.get_sales_by_date(date)
    if date.present?
      date = Time.zone.parse(date)
      sales = Sale.where(created_at: date.beginning_of_day..date.end_of_day)
    else
      sales = Sale.all
    end

    {
      count: sales.count,
      sum_toy_values: sales.map { |s| s.toy.value }.sum,
      sales: ActiveModelSerializers::SerializableResource.new(sales)
    }
  end

  def self.get_higher_volume
    client_id, total_sales = Sale.group(:client_id)
                             .order(Arel.sql("COUNT(*) DESC"))
                             .count
                             .first

    top_client = Client.find(client_id)

    {
      total_sales: total_sales,
      client: top_client
    }
  end

  def self.get_highest_average_amount
    client_id, avg_value = Sale.joins(:toy)
                          .select("client_id, AVG(toys.value) AS avg_value")
                          .group(:client_id)
                          .order(Arel.sql("avg_value DESC"))
                          .limit(1)
                          .map { |s| [ s.client_id, s.avg_value.to_f ] }
                          .first

    top_client = Client.find(client_id)

    {
      average_value: avg_value.to_f.round(2),
      client: top_client
    }
  end

  def self.get_highest_frequency
    result = Sale.select("client_id, COUNT(DISTINCT DATE(created_at)) AS unique_days")
            .group(:client_id)
            .order(Arel.sql("unique_days DESC"))
            .limit(1)
            .first

    top_client = Client.find(result.client_id)

    {
      unique_days_of_purchase: result.unique_days.to_i,
      client: top_client
    }
  end
end
