require "spec_helper"

require "sudachi-installer/releases"

describe "Sudachi::Releases" do
  before {
    SudachiInstaller.config.jar_dir = File.join(__dir__, "/../../tmp")

    if !@releases
      @releases = SudachiInstaller::Releases.new
    end
  }

  #
  # @return [Hash]
  #
  def single_release
    if !@release
      r = JSON.parse(File.read(File.join(__dir__, "/../support/source/single-release.json")), symbolize_names: true)
      r.keys.grep(/at\z/).each { |key|
        r[key] = Time.parse(r[key])
      }
      r[:assets] = r[:assets].map { |asset|
        Hash[*asset.map { |k, v| k.to_s.end_with?("at") ? [k, Time.parse(v)] : [k, v] }.flatten]
      }

      @release = r
    end

    @release
  end

  describe "#compact_release" do
    it {
      assert {
        @releases.compact_release(single_release).instance_of? Hash
      }
    }
  end

  describe "#compact_asset" do
    it {
      assert {
        @releases.compact_asset(single_release[:assets].first).instance_of? Hash
      }
    }
  end

  describe "#latest" do
    it {
      VCR.use_cassette("release_latest") do
        assert {
          @releases.latest == @releases.compact_release(single_release)
        }
      end
    }
  end

  describe "#version" do
    describe "version not exist" do
      it {
        VCR.use_cassette("release-0.7.1") do
          assert_raises SudachiInstaller::Releases::ReleaseNotExist do
            @releases.version("v0.8.0")
          end
        end
      }
    end

    describe "version exist" do
      it {
        VCR.use_cassette("release-0.7.1") do
          @releases.version("v0.7.1")
        end
      }
    end
  end

  describe "#download" do
    it {
      VCR.use_cassette("release-0.7.1") do
        @releases.download("v0.7.1")
        resolver = SudachiInstaller::Resolver.new

        assert {
          File.basename(resolver.jar_path("0.7.1")) == "sudachi-0.7.1.jar"
        }
      end
    }
  end
end
