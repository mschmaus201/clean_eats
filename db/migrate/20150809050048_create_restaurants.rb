class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :camis, :null => false
      t.string :name, :null => false
      t.string :phone
      t.string :grade, :null => false
      t.datetime :grade_date, :null => false
      t.string :seamless_id
      t.string :building
      t.string :street
      t.string :boro
      t.string :zipcode

      t.timestamps
    end
  end
end
