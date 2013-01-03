module Heathen
  class Client
    class Response
      def initialize(body)
        @parsed = Yajl::Parser.parse(body)
      end

      def original
        @parsed['original']
      end

      def converted
        @parsed['converted']
      end

      def get(which = :converted)
        RestClient.get(send(which))
      end
    end
  end
end
