class Business < ActiveRecord::Base

  belongs_to :category
  has_one :location

end
