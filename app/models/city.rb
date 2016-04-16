# == Schema Information
#
# Table name: cities
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class City < ActiveRecord::Base
  has_many :trips
end
