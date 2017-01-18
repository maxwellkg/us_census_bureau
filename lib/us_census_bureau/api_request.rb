module UsCensusBureau
	class ApiRequest
		require 'net/http'

		BASE = "https://api.census.gov/data".freeze

		attr_accessor :api_key, :vintage, :dataset, :options
		attr_reader :response

		CREDENTIALS = {
			api_key: "0a132be88d2d9dbfde7649aa7fd494ebbbdadb50"
			}.freeze

		def initialize(key: CREDENTIALS[:api_key], vintage:, dataset:, options: {})
			@api_key, @vintage, @dataset, @options = key, vintage, dataset, options
		end

		def uri
			URI("#{BASE}/#{vintage}/#{dataset}#{options_to_params(options)}")
		end

		def request
			res = Net::HTTP.get_response(uri)
			if res.is_a?(Net::HTTPSuccess)
				@response = JSON.parse(res.body)
			else
				raise Error res
			end
		end

		def options_to_params(options)
			validate_options(options)
			if options[:variables] == true
				"/variables"
			else
				opts_with_key = options.merge('key' => @api_key)
				'?' + URI.encode_www_form(opts_with_key) unless options.empty?
			end
		end

		private

			def validate_options(options)
				if options[:variables] == true
					raise "You have incorrectly specified options! #{options}" if options.size > 1
				elsif options[:get].present? && options[:for].nil?
					raise "You must also specify a 'for' argument when using 'get'"
				end
			end

	end
end