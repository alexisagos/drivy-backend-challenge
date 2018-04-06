# Define Rental class
class Rental
	attr_accessor :id, :car, :start_date, :end_date, :distance, :options

	def initialize(id, car, start_date, end_date, distance)
		@id = id
		@car = car
		car.rentals << self
		@start_date = start_date
		@end_date = end_date
		@distance = distance
		@options = []
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

	def gps_option
		# If rental has gps option, it will cost 5€/day
		options.any? { |option| option.type == "gps" } ? 500 * rental_days : 0
	end

	def baby_seat_option
		# If rental has baby seat option, it will cost 2€/day
		options.any? { |option| option.type == "baby_seat" } ? 200 * rental_days : 0
	end

	def additional_insurance_option
		# If rental has additional insurance option, it will cost 10€/day
		options.any? { |option| option.type == "additional_insurance" } ? 1000 * rental_days : 0
	end

	# Price paid by driver
	def driver_debit
		# Price of car rental plus additional options
		price + gps_option + baby_seat_option + additional_insurance_option
	end

	# Car owner's credit
	def owner_credit
		# 70% of the rental price goes to the owner plus money from gps or baby seat options
		(price * 0.70).to_i + gps_option + baby_seat_option
	end

	# Drivy's credit
	def drivy_credit
		# Drivy's fee plus additional insurance option
		drivy_fee + additional_insurance_option
	end
end
