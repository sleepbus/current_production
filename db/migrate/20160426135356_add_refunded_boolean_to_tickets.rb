class AddRefundedBooleanToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :refunded, :boolean, default: false
  end
end
