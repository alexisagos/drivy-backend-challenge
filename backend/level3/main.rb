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

	# Compute number of rental days
	def rental_days
		rental_days = 1 + (Date.parse(@end_date) - Date.parse(@start_date)).to_i
	end

	def price
		# Compute time component of price
		time_component = 0
		for i in 1..rental_days
			adjusted_price_per_day = @car.price_per_day

			# Price per day decreases by 10% after 1 day
			if i > 1
				adjusted_price_per_day = @car.price_per_day * 0.90
			end

			# Price per day decreases by 30% after 4 days
			if i > 4
				adjusted_price_per_day = @car.price_per_day * 0.70
			end

			# Price per day decreases by 50% after 10 days
			if i > 10
				adjusted_price_per_day = @car.price_per_day * 0.50
			end

			time_component += adjusted_price_per_day.to_i
		end

		# Compute distance component
		distance_component = @distance * @car.price_per_km

		# Return rental price
		time_component + distance_component
	end

	# Compute total commision
	def commision
		# 30% commission on the rental price
		(price * 0.30).to_i
	end

	def insurance_fee
		# Half goes to the insurance
		(commision * 0.50).to_i
	end

	def assistance_fee
		# 1€/day goes to the roadside assistance
		rental_days * 100
	end

	def drivy_fee
		# The rest goes to us
		commision - insurance_fee - assistance_fee
	end
end

# Instantiate rentals from parsed data
rentals = data['rentals'].map do |rental|
	Rental.new(rental['id'], cars.find { |car| car.id == rental['car_id'] }, rental['start_date'], rental['end_date'], rental['distance'])
end

# Prepare output to write in JSON output file
output = {
	"rentals": rentals.map do |rental|
		{
			id: rental.id,
			price: rental.price,
			commission: {
				insurance_fee: rental.insurance_fee,
				assistance_fee: rental.assistance_fee,
				drivy_fee: rental.drivy_fee
			}
		}
	end
}

# Write to output JSON file
File.open("data/output.json", "w") do |f|
	f.write(JSON.pretty_generate(output))
end
