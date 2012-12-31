require 'heathen-client/version'
require 'heathen-client/interface'

require 'uri'
require 'yajl'
require 'rest_client'

module Heathen
  class Client

    extend Heathen::Client::Interface

    DEFAULT_BASE_URI = 'http://redgem.ifad.org/heathen'

    @@client = nil

    def self.client
      @@client ||= new
    end

    def self.client=(c)
      @@client = c
    end

    def initialize(options = { })
      @base_uri = URI.parse(options.fetch(:base_uri, DEFAULT_BASE_URI))
    end

    def convert(action, options)

      options.merge!(action: action)

      # in Rails, Hash has a read method, but this makes
      # RestClient think that the hash is a File. bah.
      class << options
        def respond_to?(*args)
          args.first.to_s == 'read' ? false : super
        end
      end

      RestClient.post(@base_uri.to_s + '/convert', options) do |response|
        Yajl::Parser.parse(response.body)
      end
    end

    def download(url, options)
      dir = Pathname(options.fetch(:dir))

      unless dir.directory?
        raise "Not a directory: #{dir}"
      end

      RestClient.get((@base_uri + URI.parse(url).path).to_s) do |response|
        disposition = response.headers[:content_disposition]
        filename    = URI.decode(disposition.match(/filename\=\"(.+?)\"/)[1])
        File.open(dir + filename, "wb") { |f| f.write(response.body) }
      end
    end
  end
end
