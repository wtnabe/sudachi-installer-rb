require "octokit"
require_relative "../sudachi-installer"
require_relative "./downloader"

module SudachiInstaller
  #
  # GitHub releases
  #
  class Releases
    class ReleaseNotExist < Error; end # rubocop:disable Layout/EmptyLineBetweenDefs
    class AssetsAmbiguous < Error; end # rubocop:disable Layout/EmptyLineBetweenDefs

    def initialize(httpclient: Faraday)
      @octokit = Octokit::Client.new
      @http = httpclient
    end

    #
    # @return [string]
    #
    def repo
      "WorksApplications/Sudachi"
    end

    #
    # @param [Hash] release
    # @return [Hash]
    #
    def compact_release(release)
      {
        id: release[:id],
        name: release[:name],
        tag_name: release[:tag_name],
        url: release[:url],
        html_url: release[:html_url],
        target_commitish: release[:target_commitish],
        created_at: release[:created_at],
        published_at: release[:published_at],
        assets: release[:assets].map { |asset| compact_asset(asset) }
      }
    end

    #
    # @param [Hash] asset
    # @return [Hash]
    #
    def compact_asset(asset)
      {
        url: asset[:url],
        name: asset[:name],
        content_type: asset[:content_type],
        created_at: asset[:created_at],
        updated_at: asset[:updated_at],
        browser_download_url: asset[:browser_download_url],
        body: asset[:body]
      }
    end

    #
    # setup octokit
    #
    def prefetch
      @repo = @octokit.repo(repo)
      @endpoint = @repo.rels[:releases]
    end

    #
    # fetch releases
    #
    def fetch
      if !@releases
        prefetch
        @releases = @endpoint.get.data
      end
    end

    #
    # @return [Array]
    #
    def list(type: "compact")
      fetch

      case type
      when "minimum"
        minimum_list
      when "compact"
        @releases.map { |release| compact_release(release) }
      else
        @releases
      end
    end

    #
    # @return [Array]
    #
    def minimum_list
      fetch

      @releases.map { |release|
        {
          id: release[:id],
          tag_name: release[:tag_name]
        }
      }
    end

    #
    # @param [boolean] compact
    # @return [Hash]
    #
    def latest(compact: true)
      prefetch
      release = @octokit.get(@endpoint.href + "/latest")

      if compact
        compact_release(release)
      else
        release
      end
    end

    #
    # @param [String] tag
    # @param [boolean] compact
    # @return [<Hash, nil>]
    #
    def version(tag, compact: false)
      release = minimum_list.find { |r| r[:tag_name] == tag }

      if release
        release_info = @octokit.get(@endpoint.href + "/#{release[:id]}")
        if compact
          compact_release(release_info)
        else
          release_info
        end
      else
        raise ReleaseNotExist.new(tag)
      end
    end

    #
    # @param [String] tag
    # @return [void]
    #
    def download(tag)
      rel = version(tag, compact: true)
      assets = rel[:assets]

      raise AssetsAmbiguous.new(tag) if assets.size > 1

      Downloader.new.download(
        assets.first[:browser_download_url],
        assets.first[:name],
        SudachiInstaller.config.jar_dir
      )
    end
  end
end
