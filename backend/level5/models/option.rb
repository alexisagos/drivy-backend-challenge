# Define Option class
class Option
	attr_accessor :id, :rental, :type

	def initialize(id, rental, type)
		@id = id
		@rental = rental
		rental.options << self
		@type = type
	end
end
