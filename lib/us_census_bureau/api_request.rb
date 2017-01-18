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
			opts_with_key = options.merge('key' => @api_key)
			URI("#{BASE}/#{vintage}/#{dataset}#{options_to_params(opts_with_key)}")
		end

		def request
			res = Net::HTTP.get_response(uri)
			if res.is_a?(Net::HTTPSuccess)
				@response = JSON.parse(res.body)
			else
				raise res.body
			end
		end

		def options_to_params(options)
			'?' + options.map { |k,v| "#{k}=#{v}" }.join("&") unless options.empty?
		end

	end
end