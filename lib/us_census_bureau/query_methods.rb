module UsCensusBureau
  module QueryMethods

    def select(*fields)
      querify!._select!(fields)
    end

    def _select!(*fields)
      self.selection_points = fields
      self
    end

    def for(options)
      querify!._for!(options)
    end

    def _for!(options)
      self.for_criteria = [options]
      self
    end

    def where(**options)
      querify!._where!(options)
    end

    def _where!(**options)
      vintage = options.delete(:vintage)

      self.vintage = vintage
      self
    end

    private

      def querify!
        self.is_a?(Query) ? self : Query.new(model: self)
      end


  end
end
