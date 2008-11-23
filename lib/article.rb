require 'rubygems'
require 'BlueCloth'

class Article
  attr_accessor :blog_id, :title, :content

  def self.from_file(filename)
    art = Article.new
    File.open(filename, "r") do |file|
      art.blog_id = file.readline()
      file.readline()
      art.title = file.readline()
      file.readline()
      art.content = ''
      while (!file.eof?)
        art.content += file.readline()
      end
    end
    art
  end

  def content_as_html
    BlueCloth.new(content()).to_html
  end
end
