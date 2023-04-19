require "faraday"
require "rexml"
require "xmlhasher"
require_relative "./downloader"

module SudachiInstaller
  #
  # dictionary index and download
  #
  class Dicts
    #
    # @param [Object] httpclient
    #
    def initialize(httpclient: Faraday)
      @http = httpclient
      @endpoint = {
        index: "https://sudachi.s3-ap-northeast-1.amazonaws.com",
        zip: "http://sudachi.s3-website-ap-northeast-1.amazonaws.com"
      }
    end

    #
    # @return [string]
    #
    def fetch
      @http.get(@endpoint[:index]).body
    end

    #
    # @return [Array]
    #
    def prefixes
      [:dict, :synonym]
    end

    #
    # @param [Symbol] type
    # @return [RegExp]
    #
    def re_template(type)
      case type
      when :dict
        %r{\Asudachidict/sudachi-dictionary-(latest|[0-9.]+)-(core|full|small)\.zip\z}
      when :synonym
        %r{\Asudachisynonym/sudachi-synonym-(latest|[0-9.]+)\.zip\z}
      end
    end

    #
    # @overload url(type, param1, ...)
    #   @param [Symbol] type
    #   @param [string] param1
    #   @param [string] ...
    # @return [String]
    #
    def url(type, *param)
      case type
      when :dict
        "sudachidict/sudachi-dictionary-#{param[0]}-#{param[1]}.zip"
      when :synonym
        "sudachisynonym/sudachi-synonym-#{param[0]}.zip"
      end
    end

    #
    # parse xml Contents/ 以下
    #
    # @param [String] document
    # @return [Array]
    #
    def index(document = fetch)
      if !@index
        doc = REXML::Document.new(document)
        @index = REXML::XPath.match(doc, "//Contents").map { |content|
          XmlHasher.parse(content.to_s)[:Contents]
        }
      end

      @index
    end

    #
    # @param [Symbol] type
    # @return [Array]
    #
    def revisions(type)
      index.map { |e|
        re_template(type).match(e[:Key])
      }.compact.map { |m|
        m.to_a[1..]
      }
    end

    #
    # @overload download(type, param1, ...)
    #   @param [Symbol] type
    #   @param [String] param1
    #   @param [String] ...
    #
    def download(type, *param)
      source = url(type, *param)
      filename = File.basename(source)

      Downloader.new.download(
        File.join(@endpoint[:zip], source),
        filename,
        SudachiInstaller.config.dict_dir
      )
    end
  end
end
