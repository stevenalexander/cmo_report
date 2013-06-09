# encoding: utf-8
require 'jekyll'
require_relative "../_plugins/data_generator.rb"
require_relative "../_plugins/helpers/xls_parser.rb"

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

  describe "get_all_data_file_paths" do
    it "should return all xls file paths under the base folder including sub dirs" do
      file_paths = @data_generator.get_all_data_file_paths("_spec/test_data")

      file_paths.length.should eq 3
      file_paths[0].should eq "_spec/test_data/graphs_38_C1_G1.xls"
      file_paths[1].should eq "_spec/test_data/maps_36_C1_M1.xls"
      file_paths[2].should eq "_spec/test_data/sub dir1/56 C2 G1 Life Expectancy.xls"
    end
  end

  describe "parse_data_file" do
    it "should call XlsParser with the file_path and the output dir" do
      file_path = "_spec/test_data/sub dir1/56 C2 G1 Life Expectancy.xls"
      output_path = "_spec/test_data"

      xls_parser = double()
      xls_parser.stub(:generate_json)
      XlsParser.should_receive(:new).with(file_path).and_return(xls_parser)
      xls_parser.should_receive(:generate_json).with(output_path + "/56-c2-g1-life-expectancy.json")

      @data_generator.parse_data_file(file_path, output_path)
    end
  end
end