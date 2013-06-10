require 'find'
require 'fileutils'
require_relative 'extensions/string.rb'
require_relative 'helpers/xls_parser.rb'

class DataGenerator

  GRAPHS_FOLDER = "_processors/data/CMO Report - Graphs"
  MAPS_FOLDER   = "_processors/data/CMO Report - Maps"

  GRAPHS_OUTPUT_FOLDER = "graphs"
  MAPS_OUTPUT_FOLDER   = "maps"

  def generate
    graphs_file_paths = get_all_data_file_paths(GRAPHS_FOLDER)
    maps_file_paths   = get_all_data_file_paths(MAPS_FOLDER)

    ensure_directory_exists(GRAPHS_OUTPUT_FOLDER)
    ensure_directory_exists(MAPS_OUTPUT_FOLDER)

    parse_data_files(graphs_file_paths, GRAPHS_OUTPUT_FOLDER)
    parse_data_files(maps_file_paths, MAPS_OUTPUT_FOLDER)
  end

  def ensure_directory_exists(dir_path)
    unless File.directory?(dir_path)
      FileUtils.mkdir_p(dir_path)
    end
  end

  def parse_data_files(file_paths, output_folder)
    file_paths.each do |path|
      json_file_name = parse_data_file(path, output_folder)
    end
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

    file_name = File.basename(file_path)
    json_file_path = output_folder + "/" + file_name.gsub(".xls", ".json").to_slug

    if !File.exist?(json_file_path)
      XlsParser.new(file_path).generate_json(json_file_path)
      puts "parsed json file : #{json_file_path}"
    end

    File.basename(json_file_path)
  end
end