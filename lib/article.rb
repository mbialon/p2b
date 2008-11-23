require 'rubygems'
require 'BlueCloth'

module Post2Blogger
  class Article
    attr_accessor :blog_id, :title, :content, :categories

    def self.from_file(filename)
      art = Article.new
      File.open(filename, "r") do |file|
        art.blog_id = file.readline().chomp
        file.readline()
        art.title = file.readline().chomp
        categories = file.readline().chomp()
        categories.split(",").each { |c| art.categories << c.strip }
        file.readline()
        art.content = ''
        while (!file.eof?)
          art.content += file.readline()
        end
      end
      art
    end

    def initialize
      @categories = []
    end

    def content_as_html
      BlueCloth.new(content()).to_html
    end
  end
end
