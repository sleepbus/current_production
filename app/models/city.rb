# == Schema Information
#
# Table name: cities
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class City < ActiveRecord::Base
  has_many :trips

  def pick_drop_location
    name == 'San Francisco, Ca' ? 'SF Caltrain, 4th and King' : 'Santa Monica Pier, 1366 Ocean Front Walk'
  end
end
