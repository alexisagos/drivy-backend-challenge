require "json"
require "date"

# Require model files
require "./models/car"
require "./models/rental"
require "./models/option"

# Read json input file
file = File.read("data/input.json")

# Parse json
data = JSON.parse(file)

# Instantiate cars from parsed data
cars = data['cars'].map do |car|
	Car.new(car['id'], car['price_per_day'], car['price_per_km'])
end

# Instantiate rentals from parsed data
rentals = data['rentals'].map do |rental|
	Rental.new(rental['id'], cars.find { |car| car.id == rental['car_id'] }, rental['start_date'], rental['end_date'], rental['distance'])
end

# Instantiate options from parsed data
options = data['options'].map do |option|
	Option.new(option['id'], rentals.find { |rental| rental.id == option['rental_id'] }, option['type'])
end

# Prepare output
output = {
	"rentals": rentals.map do |rental|
		{
			id: rental.id,
			options: rental.options.map { |option| option.type },
			actions: [
				{
					who: "driver",
					type: "debit",
					amount: rental.driver_debit
				},
				{
					who: "owner",
					type: "credit",
					amount: rental.owner_credit
				},
				{
					who: "insurance",
					type: "credit",
					amount: rental.insurance_fee
				},
				{
					who: "assistance",
					type: "credit",
					amount: rental.assistance_fee
				},
				{
					who: "drivy",
					type: "credit",
					amount: rental.drivy_credit
				}
			]
		}
	end
}

# Write to output JSON file
File.open("data/output.json", "w") do |f|
	f.write(JSON.pretty_generate(output))
end
