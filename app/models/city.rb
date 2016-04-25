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
    name == 'San Francisco, Ca' ? '333-399 Townsend St, San Francisco, CA 94107 (between 4th and 5th street)' : 'Santa Monica Pier, 1366 Ocean Front Walk'
  end
end
