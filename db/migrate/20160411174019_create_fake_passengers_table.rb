class CreateFakePassengersTable < ActiveRecord::Migration
  def change
  	create_table :fake_passengers do |f|
  		f.string :first_name
  		f.string :last_name
  		f.string :email
      f.string :phone_number
  	end
  end
end
