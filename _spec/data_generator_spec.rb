# encoding: utf-8
require 'jekyll'
require_relative "../_plugins/data_generator.rb"

include Jekyll

describe DataGenerator do
  before(:each) do
    @data_generator = DataGenerator.new
  end

  describe "generate" do
    it "should generate the site from the data" do
      true.should be_true
    end
  end
end