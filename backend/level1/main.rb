require "json"
require "date"

# Read json input file
file = File.read("data/input.json")
# Parse json
data = JSON.parse(file)

# Define Car class
class Car
	attr_accessor :id, :price_per_day, :price_per_km

	def initialize(id, price_per_day, price_per_km)
		@id = id
		@price_per_day = price_per_day
		@price_per_km = price_per_km
	end
end

# Instantiate cars from parsed data
cars = data['cars'].map do |car|
	Car.new(car['id'], car['price_per_day'], car['price_per_km'])
end

# Define Rental class
class Rental
	attr_accessor :id, :car, :start_date, :end_date, :distance

	def initialize(id, car, start_date, end_date, distance)
		@id = id
		@car = car
		@start_date = start_date
		@end_date = end_date
		@distance = distance
	end

	def price
		# Compute number of rental days
		rental_days = 1 + (Date.parse(end_date) - Date.parse(start_date)).to_i

		# Compute time component of price
		time_component = rental_days * @car.price_per_day

		# Compute distance component
		distance_component = @distance * @car.price_per_km

		# Return rental price
		time_component + distance_component
	end
end

# Instantiate rentals from parsed data
rentals = data['rentals'].map do |rental|
	Rental.new(rental['id'], cars.find { |car| car.id == rental['car_id'] }, rental['start_date'], rental['end_date'], rental['distance'])
end

# Prepare output to write in JSON output file
output = {
	"rentals": rentals.map { |rental| {id: rental.id, price: rental.price} }
}

# Write to output JSON file
File.open("data/output.json", "w") do |f|
	f.write(JSON.pretty_generate(output))
end
