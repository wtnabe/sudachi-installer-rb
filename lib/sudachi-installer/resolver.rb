require_relative "../sudachi-installer"

module SudachiInstaller
  #
  # downloaded file resolver
  #
  class Resolver
    include SudachiInstaller

    class ExecutableVersionNotDownloaded < Error; end # rubocop:disable
    class DictionaryNotDownloaded < Error; end # rubocop:disable

    #
    # @return [string]
    #
    def jar_dir
      self.class.ancestors[1].config.jar_dir
    end

    #
    # @return [String]
    #
    def dict_dir
      self.class.ancestors[1].config.dict_dir
    end

    #
    # @return [Array]
    #
    def executable_jars
      Dir.chdir(jar_dir) {
        Dir.glob("sudachi-*-executable").select { |f|
          FileTest.directory? f
        }
      }
    end

    #
    # @param [String] revision
    # @return [String]
    #
    def jar_path(revision)
      dir = executable_jars.find { |e| e == "sudachi-#{revision}-executable" }

      if dir
        File.join(jar_dir, dir, "sudachi-#{revision}.jar")
      else
        raise ExecutableVersionNotDownloaded.new(dir)
      end
    end

    #
    # @return [Array]
    #
    def dictionaries
      Dir.chdir(dict_dir) {
        Dir.glob("sudachi-dictionary-*").select { |f|
          FileTest.directory? f
        }
      }
    end

    #
    # @param [String] revision
    # @param [String] edition
    # @return [String]
    #
    def dict_path(revision:, edition: "core")
      dir = dictionaries.find { |e| e == "sudachi-dictionary-#{revision}" }

      if dir
        File.join(dict_dir, dir, "system_#{edition}.dic")
      else
        raise DictionaryNotDownloaded.new({revision: revision, edition: edition}.to_s)
      end
    end
  end
end
