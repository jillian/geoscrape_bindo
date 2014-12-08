class Business < ActiveRecord::Base

  belongs_to :categories
  has_one :location

end
