class AddCreatedAtToFakeTickets < ActiveRecord::Migration
  def change
    add_column :fake_tickets, :created_at, :datetime
  end
end
