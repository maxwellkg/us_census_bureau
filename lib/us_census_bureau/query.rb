module UsCensusBureau
  class Query
    include QueryMethods

    attr_accessor :vintage, :model, :selection_points, :for_criteria

    def initialize(vintage: nil, model:, selection_points: [], for_criteria: [])
      @vintage, @model, @selection_points, @for_criteria = vintage, model, selection_points, for_criteria
      @loaded = false
    end

    def execute
      validate_for_execution

      opts = {}
      opts[:get] = selection_points.flatten if !selection_points.empty?
      opts[:for] = for_criteria.flatten if !for_criteria.empty?

      req = ApiRequest.new(vintage: vintage, dataset: @model.send(:id), options: opts)
      @results = @model.new(req.request)
      @loaded = true
      @results
    end

    def loaded?
      @loaded == true
    end

    def load
      execute unless loaded?
    end

    def to_a
      self.load
      @results
    end

    def inspect
      entries = self.to_a.dup

      if entries.respond_to?(:map)
        entries.map!(&:inspect)
        if entries.size > 10
          entries = entries[0..9]
          entries[10] = '...'
        end

        "#<#{self.class.name} [#{entries.join(', ')}]>"
      else
        entries.inspect
      end
    end

    private

      def validate_for_execution
        raise "Invalid query: #{self}" unless @vintage.present? && @model.present?
        @model.send(:validate_year, vintage)
      end

      def method_missing(method, *args, &block)
        to_a.send(method, *args, &block)
      end

  end
end
