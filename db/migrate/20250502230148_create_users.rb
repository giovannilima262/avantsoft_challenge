class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :password_digest, null: false
      t.boolean :admin, default: false
    end
    User.create!(name: "admin", password: "admin", admin: true) # TODO
  end
end
