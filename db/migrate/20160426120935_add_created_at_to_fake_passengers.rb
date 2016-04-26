class AddCreatedAtToFakePassengers < ActiveRecord::Migration
  def change
    add_column :fake_passengers, :created_at, :datetime
  end
end
