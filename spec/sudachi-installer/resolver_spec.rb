require "spec_helper"

require "sudachi-installer/resolver"

describe SudachiInstaller::Resolver do
  describe "jar" do
    before {
      SudachiInstaller.config.jar_dir = File.join(__dir__, "../support/downloaded/jar")
      SudachiInstaller.config.dict_dir = File.join(__dir__, "../support/downloaded/dict")
      @resolver = SudachiInstaller::Resolver.new
    }

    describe "#jar_path" do
      it "0.7.1" do
        assert {
          @resolver.jar_path("0.7.1").instance_of? String
        }
      end

      it "0.5.0" do
        assert_raises SudachiInstaller::Resolver::ExecutableVersionNotDownloaded do
          @resolver.jar_path("0.5.0")
        end
      end
    end

    describe "#dict_path" do
      it "20230110" do
        assert {
          @resolver.dict_path(revision: "20230110", edition: "small").instance_of? String
        }
      end

      it "20221021" do
        assert_raises do
          @resolver.dict_path(revision: "20221021")
        end
      end
    end
  end
end
