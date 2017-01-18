module UsCensusBureau 
 class EconomicCensusVariable
    attr_reader :name, :label, :concept

    def initialize(attrs)
      @name, @label, @concept, @year = attrs
    end

    def self.all(year)
      EconomicCensus.variables(year).collect { |v| new(v + [year]) }
    end

  end
end
