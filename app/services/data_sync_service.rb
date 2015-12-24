require 'rest_client'

class DataSyncService
  BASE_URL = "http://data.cityofnewyork.us/resource/43nn-pn8j.json"

  def initial_data_download
    response_count = nil
    offset = 0
    limit = 50_000

    while response_count != 0 do
      url = "#{BASE_URL}?$offset=#{offset}&$limit=#{limit}"
      response = JSON.parse(RestClient.get(url))
      response_count = response.count
      offset += limit

      response.each do |entry|
        next unless entry['grade_date']

        restaurant = Restaurant.find_by_camis(entry['camis'])
        create_or_update_restaurant(restaurant, entry)
      end
    end
  end

  private

    def create_or_update_restaurant(restaurant, entry)
      if restaurant
        update_restaurant_grade(restaurant, entry)
      else
        create_restaurant(entry)
      end
    end

    def create_restaurant(entry)
      Restaurant.create(
        :name => entry['dba'],
        :camis => entry['camis'],
        :phone => entry['phone'],
        :grade => entry['grade'],
        :grade_date => response_grade_date(entry),
        :building => entry['building'],
        :street => entry['street'],
        :boro => entry['boro'],
        :zipcode => entry['zipcode'],
    )
    end

    def update_restaurant_grade?(restaurant, entry)
      restaurant && restaurant.grade_date < response_grade_date(entry)
    end

    def update_restaurant_grade(restaurant, entry)
      return unless update_restaurant_grade?(restaurant, entry)

      restaurant.grade_date = response_grade_date(entry)
      restaurant.grade = entry['grade']
      restaurant.save!
    end

    def response_grade_date(entry)
      Time.parse(entry['grade_date'])
    end
end










