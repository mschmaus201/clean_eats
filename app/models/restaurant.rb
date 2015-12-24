class Restaurant < ActiveRecord::Base
  attr_accessible :camis, :phone, :name, :grade, :grade_date, :seamless_id, :building, :street, :boro, :zipcode
end
