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
    end

    def parse_data_file(file_path, output_folder)
    end
  end
end