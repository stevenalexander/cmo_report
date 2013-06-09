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
      data_generator = DataGenerator.new
      data_generator.stub(:get_all_data_file_paths).and_return(["file_path1","file_path2"])
      data_generator.stub(:parse_data_file)

      data_generator.should_receive(:get_all_data_file_paths).with(DataGenerator::GRAPHS_FOLDER).once.ordered
      data_generator.should_receive(:get_all_data_file_paths).with(DataGenerator::MAPS_FOLDER).once.ordered
      data_generator.should_receive(:parse_data_file).with("file_path1", DataGenerator::GRAPHS_OUTPUT_FOLDER)
      data_generator.should_receive(:parse_data_file).with("file_path2", DataGenerator::GRAPHS_OUTPUT_FOLDER)
      data_generator.should_receive(:parse_data_file).with("file_path1", DataGenerator::MAPS_OUTPUT_FOLDER)
      data_generator.should_receive(:parse_data_file).with("file_path2", DataGenerator::MAPS_OUTPUT_FOLDER)

      data_generator.generate(@path)
    end
  end
end