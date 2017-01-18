module UsCensusBureau
	class Dataset
    extend QueryMethods

    class << self
      attr_reader :id, :available_years
      attr_accessor :variables
    end

		def self.where(options)
			vintage = options.delete(:vintage)
      validate_year(vintage)
			ApiRequest.new(vintage: vintage, dataset: @id, options: options).request
		end

    def self.validate_year(year)
      unless @available_years.include?(year)
        raise "#{year} is not a valid year. Valid years for #{self} are: #{@available_years.join(', ')}"
      end
    end

    def self.variables(year)
      @variables ||= {}
      @variables[year] ||= get_variables(year)
    end

    def initialize(attrs)
      headers = attrs.first

    end

    private

      def self.get_variables(year)
        validate_year(year)
        begin
          ApiRequest.new(vintage: year, dataset: @id, options: {variables: true} ).request
        rescue
          "No variables are available for this data set"
        end
      end

	end
end
