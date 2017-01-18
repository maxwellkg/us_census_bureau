module UsCensusBureau
  class Query
    include QueryMethods

    attr_accessor :vintage, :model, :selection_points, :for_criteria

    def initialize(vintage: nil, model:, selection_points: [], for_criteria: [])
      @vintage, @model, @selection_points, @for_criteria = vintage, model, selection_points, for_criteria
      @loaded = false
    end

    def execute
      if !loaded?
        validate_for_execution

        opts = {}
        opts[:get] = selection_points.flatten if !selection_points.empty?
        opts[:for] = for_criteria.flatten if !for_criteria.empty?

        @results = ApiRequest.new(vintage: vintage, dataset: @model.send(:id), options: opts).request
        @loaded = true
      end
      @results
    end

    def loaded?
      @loaded == true
    end

    private

      def validate_for_execution
        raise "Invalid query: #{self}" unless @vintage.present? && @model.present?
        @model.send(:validate_year, vintage)
      end

  end
end
