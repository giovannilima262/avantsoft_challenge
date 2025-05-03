class SeedInitialData < ActiveRecord::Migration[8.0]
  def up
    client1 = Client.create!(name: 'Alice', email: 'alice@example.com')
    client2 = Client.create!(name: 'Bob', email: 'bob@example.com')
    client3 = Client.create!(name: 'Ricardo', email: 'ricardo@example.com')

    toy1 = Toy.create!(name: 'Carrinho', value: 29.90)
    toy2 = Toy.create!(name: 'Boneca', value: 49.50)
    toy3 = Toy.create!(name: 'Maxtill', value: 98.90)
    toy4 = Toy.create!(name: 'Patins', value: 199.90)
    toy5 = Toy.create!(name: 'Laptop da xuxa', value: 64.70)

    Sale.create!(toy_id: toy1.id, client_id: client1.id)
    Sale.create!(toy_id: toy3.id, client_id: client1.id)
    Sale.create!(toy_id: toy4.id, client_id: client1.id)
    Sale.create!(toy_id: toy2.id, client_id: client2.id)
    Sale.create!(toy_id: toy5.id, client_id: client2.id)
  end

  def down
    Sale.delete_all
    Toy.delete_all
    Client.delete_all
  end
end
