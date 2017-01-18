class EconomicCensusVariable
  attr_reader :name, :label, :concept

  def initialize(*attrs)
    @name, @label, @concept = attrs
  end

end
