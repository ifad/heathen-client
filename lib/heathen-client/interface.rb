module Heathen
  class Client
    module Interface
      def office_to_pdf(path)
        client.convert(:office_to_pdf, file: File.open(path))
      end

      def html_to_pdf(path)
        client.convert(:html_to_pdf, file: File.open(path))
      end

      def url_to_pdf(url)
        client.convert(:url_to_pdf, url: url)
      end

      def download(url, dir)
        client.download(url, dir: dir)
      end
    end
  end
end
