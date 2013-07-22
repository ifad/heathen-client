module Heathen
  class Client
    module Interface

      def pdf(args = { })
        convert(:pdf, shared_args(args))
      end

      def docx(args = { })
        convert(:docx, shared_args(args))
      end

      def ocr(args = { })
        convert(:ocr, shared_args(args).merge(language: args.fetch(:language)))
      end

      def convert(action, options)
        client.convert(action, options)
      end

      private

        def shared_args(args)

          shared = { }

          if file = args[:file]
            shared[:file]      = file.is_a?(IO) ? file : File.new(file, "rb")
            shared[:multipart] = true

          elsif url = args[:url]
            shared[:url] = URL.parse(url).to_s
          end

          shared
        end
    end
  end
end
