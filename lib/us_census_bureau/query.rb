module UsCensusBureau
  class Query

    attr_accessor :year, :model, :selection_points, :for_criteria

    def initialize(year:, model:, selection_points: [], for_criteria: [])
      @year, @model, @selection_points, @for_criteria = year, model, selection_points, for_criteria
      @loaded = false
    end

    def execute
      if !loaded?
        validate_for_execution

        opts = {}
        opts[:get] = selection_points if !selection_points.empty?
        opts[:for] = for_criteria if !for_criteria.empty?

        @results = ApiRequest.new(vintage: year, dataset: @model.send(:id), options: opts).request
        @loaded = true
      end
      @results
    end

    def loaded?
      @loaded == true
    end

    private

      def validate_for_execution
        raise "Invalid query: #{self}" unless @year.present? && @model.present?
        @model.send(:validate_year, year)
      end

  end
end
