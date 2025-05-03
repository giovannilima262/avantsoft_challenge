class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales, id: :uuid do |t|
      t.references :toy, type: :uuid, foreign_key: true
      t.references :client, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
