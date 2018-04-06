# Define Car class
class Car
	attr_accessor :id, :price_per_day, :price_per_km, :rentals

	def initialize(id, price_per_day, price_per_km)
		@id = id
		@price_per_day = price_per_day
		@price_per_km = price_per_km
		@rentals = []
	end
end
