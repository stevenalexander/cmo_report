require 'find'
require_relative 'extensions/string.rb'

module Jekyll
  class DataGenerator < Generator
    safe true
    priority :low

    GRAPHS_FOLDER = "_plugins/data/CMO Report - Graphs"
    MAPS_FOLDER   = "_plugins/data/CMO Report - Maps"

    GRAPHS_OUTPUT_FOLDER = "graphs"
    MAPS_OUTPUT_FOLDER   = "maps"

    def generate(site)
      graphs_file_paths = get_all_data_file_paths(GRAPHS_FOLDER)
      maps_file_paths   = get_all_data_file_paths(MAPS_FOLDER)

      graphs_file_paths.each { |path| parse_data_file(path, GRAPHS_OUTPUT_FOLDER) }
      maps_file_paths.each   { |path| parse_data_file(path, MAPS_OUTPUT_FOLDER) }
    end

    def get_all_data_file_paths(base_folder)
      xls_file_paths = []

      Find.find(base_folder) do |path|
        xls_file_paths << path if path =~ /.*\.xls$/
      end

      xls_file_paths
    end

    def parse_data_file(file_path, output_folder)
      return nil if !File.exist?(file_path)

      puts "parsing data file : #{file_path}"

      file_name = File.basename(file_path)
      json_file_path = output_folder + "/" + file_name.gsub(".xls", ".json").to_slug

      XlsParser.new(file_path).generate_json(json_file_path)

      puts "parsed json file : #{json_file_path}"
    end
  end
end