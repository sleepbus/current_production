class CreateFakeTicketsTable < ActiveRecord::Migration
  def change
  	create_table :fake_tickets do |f|
  		f.integer :fake_passenger_id
      f.integer :depart_city_id
      f.integer :return_depart_city_id
      f.date    :depart_date
      f.date    :return_depart_date
  	end
  end
end
