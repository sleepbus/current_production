# == Schema Information
#
# Table name: buses
#
#  id        :integer          not null, primary key
#  name      :string(255)
#  num_seats :integer
#

class Bus < ActiveRecord::Base
  # Remember to create a migration!
end
