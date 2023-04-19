#
# fake class for Faraday.get
#
class FaradayFake
  class << self
    #
    # @param [string] endpoint
    # @return [Object]
    #
    def get(endpoint)
      if !@xml
        @xml = Struct.new(:body).new(File.read(endpoint))
      end

      @xml
    end
  end
end
