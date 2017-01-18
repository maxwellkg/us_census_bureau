module UsCensusBureau
  class EconomicCensus < Dataset
    @id = 'ewks'
    @available_years = [2012, 2007, 2002]


    def self.variables(year)
      uri = URI("#{ApiRequest::BASE}/#{year}/#{@id}/variables")
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        JSON.parse(res.body)[1..-1].collect { |v| EconomicCensusVariable.new(v) }
      else
        raise res
      end
    end

  end

  class EconomicCensusVariable
    attr_reader :name, :label, :concept

    def initialize(*attrs)
      @name, @label, @concept = attrs
    end

  end
end
