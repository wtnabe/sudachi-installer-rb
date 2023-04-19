# frozen_string_literal: true

require "dry-configurable"
require_relative "sudachi-installer/version"

#
# Download and deploy Sudachi exectable and dictionary
#
module SudachiInstaller
  extend Dry::Configurable

  setting :dict_dir
  setting :jar_dir

  class Error < StandardError; end # rubocop:disable
  # Your code goes here...
end
