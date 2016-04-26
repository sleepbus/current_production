class AddCreatedAtToPassengers < ActiveRecord::Migration
  def change
    add_column :passengers, :created_at, :datetime
  end
end
