# encoding: utf-8
require_relative "../../_plugins/helpers/xls_parser.rb"

SAMPLE_XLS_GRAPH_PATH = "_spec/test_data/graphs_38_C1_G1.xls"
SAMPLE_XLS_MAP_PATH   = "_spec/test_data/maps_36_C1_M1.xls"

describe XlsParser do
  before(:each) do
    @xls_parser = XlsParser.new(SAMPLE_XLS_GRAPH_PATH)
  end

  describe "#new" do
    it "takes a file path parameter and returns a XlsParser object" do
      @xls_parser.should be_an_instance_of XlsParser
    end
  end
end