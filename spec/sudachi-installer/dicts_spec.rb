require "spec_helper"

require "sudachi-installer/dicts"
require "pathname"

describe "SudachiInstaller::Dicts" do
  before {
    SudachiInstaller.config.dict_dir = File.join(__dir__, "/../../tmp/")
    @dicts = SudachiInstaller::Dicts.new
  }

  #
  # @return [String]
  #
  def index_xml
    File.read(File.join(__dir__, "/../support/source/sudachi-dict.xml"))
  end

  describe "#url" do
    describe "type :dict" do
      it {
        assert {
          @dicts.url(:dict, "20230110", "small") == "sudachidict/sudachi-dictionary-20230110-small.zip"
        }
      }
    end

    describe "type :synonym" do
      it {
        assert {
          @dicts.url(:synonym, "20211220") == "sudachisynonym/sudachi-synonym-20211220.zip"
        }
      }
    end
  end

  describe "#index" do
    it {
      index = @dicts.index(index_xml)

      assert { index.instance_of? Array }
      assert { index.size > 0 }
    }
  end

  describe "#revision" do
    it {
      VCR.use_cassette("dictionaries") do
        revisions = @dicts.revisions(:dict)

        assert { revisions.instance_of? Array }
        assert { revisions.map { |e| e.class }.uniq == [Array] }
      end
    }
  end

  describe "#download" do
    # latest でも download できるけど resolve の際には指定できない
    it {
      VCR.use_cassette("dict-latest-small") do
        @dicts.download(:dict, "latest", "small")

        path = Pathname.new(SudachiInstaller::Resolver.new.dict_path(revision: "20230110", edition: "small"))
        dir = path.ascend.to_a[1].basename.to_s
        file = path.basename.to_s

        assert {
          File.join(dir, file) == "sudachi-dictionary-20230110/system_small.dic"
        }
      end
    }
  end
end
