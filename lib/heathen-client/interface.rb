module Heathen
  class Client
    module Interface
      def office_to_pdf(file)
        client.convert(:office_to_pdf, file: from_file(file), multipart: true)
      end

      def html_to_pdf(file)
        client.convert(:html_to_pdf, file: from_file(file), multipart: true)
      end

      def url_to_pdf(url)
        client.convert(:url_to_pdf, url: url)
      end

      def download(url, dir)
        client.download(url, dir: dir)
      end

      private

        def from_file(file)
          if file.respond_to?(:read)
            file
          else
            File.new(path, "rb")
          end
        end
    end
  end
end
