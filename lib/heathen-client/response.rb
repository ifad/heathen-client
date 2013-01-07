module Heathen
  class Client
    class Response
      def initialize(client, response)
        @client = client
        @status = response.code
        begin
          @parsed = Yajl::Parser.parse(response.body)
        rescue Exception => e
          @parsed = { 'error' => e.message }
        end
      end

      def original(file = nil)
        url('original', file)
      end

      def converted(file = nil)
        url('converted', file)
      end

      def error
        @parsed['error']
      end

      def success?
        error.nil?
      end

      def error?
        !error.nil?
      end

      def get(which = :converted, &block)
        unless error?
          RestClient.get(send(which), &block)
        end
      end

      protected

        def url(which, file = nil)
          @parsed[which.to_s].tap do |u|
            if u && file
              @client.download(u, file: file)
            end
          end
        end
    end
  end
end
