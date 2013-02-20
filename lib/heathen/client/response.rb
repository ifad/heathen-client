module Heathen
  class Client
    class Response

      attr_reader :data

      def initialize(client, response)
        @client = client
        @status = response.code
        begin
          @data = Yajl::Parser.parse(response.body)
        rescue Exception
          @data = { 'error' => 'Internal Server Error' }
        end
      end

      def original(file = nil)
        url('original', file)
      end

      def converted(file = nil)
        url('converted', file)
      end

      def error
        data['error']
      end

      def success?
        error.nil?
      end

      def error?
        !error.nil?
      end

      # yields data to block
      def get(which = :converted, &block)
        unless error?
          RestClient.get(send(which), &block)
        end
      end

      # convenience method
      def download(args = { })
        File.open(args[:path], "wb") do |dest|
          get(args.fetch(:which, :converted)) do |data|
            dest.write(data)
          end
          dest.path
        end
      end

      protected

        def url(which, file = nil)
          data[which.to_s].tap do |u|
            if u && file
              @client.download(u, file: file)
            end
          end
        end
    end
  end
end
