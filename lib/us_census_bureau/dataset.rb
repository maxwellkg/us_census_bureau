module UsCensusBureau
	class Dataset
    class << self; attr_reader :id, :available_years end

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

	end
end
