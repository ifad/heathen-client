module Heathen
  class Client
    class Response
      def initialize(response)
        @status = response.code
        begin
          @parsed = Yajl::Parser.parse(response.body)
        rescue Exception => e
          @parsed = { 'error' => e.message }
        end
      end

      def original
        @parsed['original']
      end

      def converted
        @parsed['converted']
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
    end
  end
end
