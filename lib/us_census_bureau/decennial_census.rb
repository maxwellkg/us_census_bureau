module UsCensusBureau
	class DecennialCensus < Dataset
    @id = 'sf1'
    @available_years = [2010, 2000, 1990]

    def self.summary(year)
      where({vintage: year})
    end

    def self.description(year)
      summary(year)['dataset'].first['description']
    end

	end
end
