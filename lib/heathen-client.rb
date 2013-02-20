require 'heathen/client/version'
require 'heathen/client/interface'
require 'heathen/client/response'

require 'uri'
require 'yajl'
require 'rest_client'
require 'pathname'

module Heathen
  class Client

    extend Interface

    DEFAULT_BASE_URI = 'http://localhost:9292'

    class << self
      def client
        @client ||= new
      end

      def client=(c)
        @client = c
      end
    end

    def initialize(options = { })
      @base_uri = URI.parse(options.fetch(:base_uri, DEFAULT_BASE_URI))
    end

    def convert(action, options)

      options.merge!(action: action)

      # in Rails, Hash has a read method, but this makes
      # RestClient think that the hash is a File.
      #
      # this fixes compatitbility with Rails without
      # needing to patch RestClient
      class << options
        def respond_to?(*args)
          args.first.to_s == 'read' ? false : super
        end
      end

      RestClient.post((@base_uri + 'convert').to_s, options) do |response|
        Response.new(self, response.body)
      end
    end

    def download(url, options)
      file = options.fetch(:file, nil)
      dir  = file ? nil : Pathname(options.fetch(:dir))

      if dir && !dir.directory?
        raise "Not a directory: #{dir}"

      elsif !file || (file && !file.respond_to?(:write))
        raise 'File or directory must be given.'
      end

      RestClient.get((@base_uri + URI.parse(url).path).to_s) do |response|
        disposition = response.headers[:content_disposition]
        filename    = URI.decode(disposition.match(/filename\=\"(.+?)\"/)[1])

        if dir
          File.open(dir + filename, "wb") { |f| f.write(response.body) }
        else
          file.write(response.body)
        end

        if file
          file.close
        end
      end
    end
  end
end
