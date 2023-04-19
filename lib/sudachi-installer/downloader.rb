require "dry-configurable"
require "down"
require "fileutils"
require "zip"

module SudachiInstaller
  #
  # download and expand archive if it is zip archive
  #
  class Downloader
    extend Dry::Configurable

    #
    # @param [string] url
    # @param [string] filename
    # @param [string] dest_dir
    #
    def download(url, filename, dest_dir)
      FileUtils.mkdir_p(dest_dir)

      Down.download(url, destination: File.join(dest_dir, filename))
      expand(File.join(dest_dir, filename), force: true) if filename.match?(/\.zip\z/i)
    end

    #
    # @param [String] path
    # @param [boolean] force
    #
    def expand(path, force: false)
      dir = File.dirname(path)

      Zip::File.open(path) { |zip|
        zip.each { |entry|
          dest = File.join(dir, entry.name)
          FileUtils.rm_rf dest if File.exist?(dest) && force
          entry.extract(File.join(dir, entry.name))
        }
      }
    end
  end
end
