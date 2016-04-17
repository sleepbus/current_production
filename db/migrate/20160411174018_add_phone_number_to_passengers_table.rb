class AddPhoneNumberToPassengersTable < ActiveRecord::Migration
  def change
  	add_column :passengers, :phone_number, :string
  end
end
