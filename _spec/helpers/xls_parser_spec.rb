# encoding: utf-8
require_relative "../../_processors/helpers/xls_parser.rb"
require 'json'
require 'spreadsheet'

SAMPLE_XLS_GRAPH_PATH = "_spec/test_data/graphs_38_C1_G1.xls"
SAMPLE_XLS_MAP_PATH   = "_spec/test_data/maps_36_C1_M1.xls"

describe XlsParser do
  before :all do
    @graph_parser = XlsParser.new(SAMPLE_XLS_GRAPH_PATH)
    @graph_summary_worksheet = @graph_parser.xls.worksheet(0)

    @graph_data_sheet_worksheet = @graph_parser.xls.worksheet(1)
    @graph_data_sheet_2_worksheet = @graph_parser.xls.worksheet(2)

    @map_parser = XlsParser.new(SAMPLE_XLS_MAP_PATH)
    @map_data_sheet_worksheet = @map_parser.xls.worksheet(0)

    #@map_parser.print_sheets
  end

  describe "#new" do
    it "takes a file path parameter and returns a XlsParser object" do
      XlsParser.new(SAMPLE_XLS_GRAPH_PATH).should be_an_instance_of XlsParser
    end
  end
  describe "#xls" do
    it "returns a workbook object" do
      parser = XlsParser.new(SAMPLE_XLS_GRAPH_PATH)
      parser.xls.should be_an_instance_of Spreadsheet::Excel::Workbook
    end
  end

  describe "is_summary_sheet" do
    it "returns true for a summary sheet" do
      @graph_parser.is_summary_sheet(@graph_summary_worksheet).should be_true
    end
    it "returns false for a data sheet" do
      @graph_parser.is_summary_sheet(@graph_data_sheet_worksheet).should be_false
      @graph_parser.is_summary_sheet(@graph_data_sheet_2_worksheet).should be_false
      @map_parser.is_summary_sheet(@map_data_sheet_worksheet).should be_false
    end
  end

  describe "is_data_sheet" do
    it "returns true for a data sheet" do
      @graph_parser.is_data_sheet(@graph_data_sheet_worksheet).should be_true
      @graph_parser.is_data_sheet(@graph_data_sheet_2_worksheet).should be_true
      @map_parser.is_data_sheet(@map_data_sheet_worksheet).should be_true
    end
    it "returns false for a summary sheet" do
      @graph_parser.is_data_sheet(@graph_summary_worksheet).should be_false
    end
  end

  describe "generate_json" do
    context "sample graph with mocks" do
      before :each do
        @parser = XlsParser.new(SAMPLE_XLS_GRAPH_PATH)
        @json_file_path = "graph.json"

        @parser.stub(:generate_summary_hash).and_return({ "Illustration reference" => "38  C1 G1" })
        @parser.stub(:generate_data_hash).and_return({ "name" => "Data sheet 1" })

        @parser.generate_json(@json_file_path)
        @content = File.read(@json_file_path) if File.exists?(@json_file_path)
        @json = JSON.parse(@content) if !@content.nil?
      end
      it "generates a json file" do
        File.exists?(@json_file_path).should be_true
      end
      it "content is json" do
        @json.nil?.should be_false
      end
      it "contains original filename" do
        @json["orginal_file_name"].should eq "graphs_38_C1_G1.xls"
      end
      it "contains summary worksheet contents" do
        @json.has_key?("summary").should be_true
        @json["summary"]["Illustration reference"].should eq "38  C1 G1"
      end
      it "contains the two Data sheet worksheet contents" do
        @json.has_key?("data").should be_true
        (@json["data"].length == 2).should be_true
        @json["data"][0]["name"].should eq "Data sheet 1"
        @json["data"][1]["name"].should eq "Data sheet 1"
      end
      after :each do
        File.delete(@json_file_path) if File.exists?(@json_file_path)
      end
    end
    context "sample map with mocks" do
      before :each do
        @parser = XlsParser.new(SAMPLE_XLS_MAP_PATH)
        @json_file_path = "map.json"

        @parser.stub(:generate_summary_hash).and_return({})
        @parser.stub(:generate_data_hash).and_return({
          :name => "Data sheet 1",
          :metadata => { "Illustration description" => "Population density by upper tier local authority, England, 2010" },
          :data => [] })

        @parser.generate_json(@json_file_path)
        @content = File.read(@json_file_path) if File.exists?(@json_file_path)
        @json = JSON.parse(@content) if !@content.nil?
      end
      it "generates a json file" do
        File.exists?(@json_file_path).should be_true
      end
      it "content is json" do
        @json.nil?.should be_false
      end
      it "contains original filename" do
        @json["orginal_file_name"].should eq "maps_36_C1_M1.xls"
      end
      it "contains the description" do
        @json["description"].should eq "Population density by upper tier local authority, England, 2010"
      end
      it "contains no summary worksheet contents" do
        @json.has_key?("summary").should be_true
        @json["summary"].nil?.should be_true
      end
      it "contains the one Data sheet worksheet contents" do
        @json.has_key?("data").should be_true
        (@json["data"].length == 1).should be_true
        @json["data"][0]["name"].should eq "Data sheet 1"
      end
      after :each do
        File.delete(@json_file_path) if File.exists?(@json_file_path)
      end
    end

    context "sample graph file" do
      before :all do
        @parser = XlsParser.new(SAMPLE_XLS_GRAPH_PATH)
        @json_file_path = "graph.json"

        @parser.generate_json(@json_file_path)
        @content = File.read(@json_file_path) if File.exists?(@json_file_path)
        @json = JSON.parse(@content) if !@content.nil?
      end
      it "generates a json file" do
        File.exists?(@json_file_path).should be_true
      end
      it "content is json" do
        @json.nil?.should be_false
      end
      it "contains original filename" do
        @json["orginal_file_name"].should eq "graphs_38_C1_G1.xls"
      end
      it "contains the description" do
        @json["description"].should eq "Population projections by age and sex 2000, 2010, 2020"
      end
      it "contains summary worksheet contents" do
        @json.has_key?("summary").should be_true
      end
      it "contains the two Data sheet worksheet contents" do
        @json.has_key?("data").should be_true
        (@json["data"].length == 2).should be_true
        @json["data"][0]["name"].should eq "Data sheet 1"
        @json["data"][1]["name"].should eq "Data sheet 1 (2)"
      end
      after :all do
        File.delete(@json_file_path) if File.exists?(@json_file_path)
      end
    end
  end

  describe "generate_summary_hash" do
    context "sample graph summary" do
      before :each do
        @summary_hash = @graph_parser.generate_summary_hash(@graph_summary_worksheet)
      end
      it "should include the summary information in the form of key value pairs" do
        @summary_hash["Illustration reference"].should eq "38  C1 G1"
        @summary_hash["x-axis label"].should eq "Population in thousands"
      end
    end
  end

  describe "generate_data_hash" do
    context "sample graph data sheet" do
      before :each do
        @data_hash = @graph_parser.generate_data_hash(@graph_data_sheet_worksheet)
      end
      it "should include the metadata from the data sheet in the form of key value pairs" do
        @data_hash.has_key?(:metadata).should be_true
        @data_hash[:metadata].keys.length.should eq 20
        @data_hash[:metadata]["Chapter"].should eq "Chapter 1: Demography"
        @data_hash[:metadata]["Significance"].should eq "Complete if applicable - Significantly better than the England average, Significantly worse than the England average, No significance can be calculated"
      end
      it "should include the data from the data sheet table section in the form an array of hashes" do
        @data_hash.has_key?(:data).should be_true
        @data_hash[:data].length.should eq 76
        @data_hash[:data][0].keys.should eq [
          "ONS 9 character code",
          "Area Code",
          "Area Name",
          "Period",
          "Gender",
          "Age group",
          "Ethnic group",
          "Deprivation grouping",
          "Numerator",
          "Denominator",
          "Indicator value",
          "Lower 95% CI",
          "Upper 95% CI",
          "Significance"
        ]

        @data_hash[:data][0]["Area Code"].should eq "Eng"
        @data_hash[:data][0]["Period"].should eq "2010"
        @data_hash[:data][0]["Age group"].should eq "0-4"
        @data_hash[:data][0]["Indicator value"].should eq 1674.8289999999997

        @data_hash[:data][1]["Area Code"].should eq "Eng"
        @data_hash[:data][1]["Period"].should eq "2010"
        @data_hash[:data][1]["Age group"].should eq "5-9"
        @data_hash[:data][1]["Indicator value"].should eq 1482.958
      end
    end

    context "sample map data sheet" do
      before :each do
        @data_hash = @map_parser.generate_data_hash(@map_data_sheet_worksheet)
      end
      it "should include the worksheet name as the name" do
        @data_hash.has_key?(:name).should be_true
        @data_hash[:name].should eq "Data sheet 1"
      end
      it "should include the metadata from the data sheet in the form of key value pairs" do
        @data_hash.has_key?(:metadata).should be_true
        @data_hash[:metadata].keys.length.should eq 20
        @data_hash[:metadata]["Chapter"].should eq "Chapter 1: Demography"
        @data_hash[:metadata]["Significance"].should eq "Complete if applicable - Significantly better than the England average, Significantly worse than the England average, No significance can be calculated"
      end
      it "should include the data from the data sheet table section in the form an array of hashes" do
        @data_hash.has_key?(:data).should be_true
        @data_hash[:data].length.should eq 152
        @data_hash[:data][0].keys.should eq [
          "ONS 9 character code",
          "Area Code",
          "Area Name",
          "Period",
          "Gender",
          "Age group",
          "Ethnic group",
          "Deprivation grouping",
          "Numerator",
          "Denominator",
          "Indicator value",
          "Lower 95% CI",
          "Upper 95% CI",
          "Significance"
        ]

        @data_hash[:data][0]["ONS 9 character code"].should eq "E06000001"
        @data_hash[:data][0]["Indicator value"].should eq 973

        @data_hash[:data][1]["ONS 9 character code"].should eq "E06000002"
        @data_hash[:data][1]["Indicator value"].should eq 2643
      end
    end
  end
end