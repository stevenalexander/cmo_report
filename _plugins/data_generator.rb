module Jekyll
  class DataGenerator < Generator
    safe true
    priority :low

    def generate(site)
      puts "generate data from data files"
    end
  end
end