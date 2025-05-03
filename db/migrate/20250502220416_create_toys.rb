class CreateToys < ActiveRecord::Migration[8.0]
  def change
    create_table :toys, id: :uuid do |t|
      t.string :name, null: false
      t.decimal :value, precision: 10, scale: 2, null: false
      t.timestamps
    end
  end
end
