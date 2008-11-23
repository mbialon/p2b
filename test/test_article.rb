require 'test/unit'
require 'rubygems'
require 'BlueCloth'

class ArticleTest < Test::Unit::TestCase
  def prepare_file
    file = mock()
    file.stubs(:name => 'foo')
    file.stubs(:readline).returns('fake_blog_id',
                                  '',
                                  'fake title',
                                  '',
                                  'fake content')
    file.stubs(:eof?).returns(false, true)
    file
  end
  
  def test_should_return_proper_blog_id
    file = prepare_file()
    File.expects(:open).with(file.name, "r").yields(file)

    art = Article.from_file(file.name)
    assert_equal 'fake_blog_id', art.blog_id
    assert_equal 'fake title', art.title
    assert_equal 'fake content', art.content
  end

  def test_should_return_content_as_html
    art = Article.new
    art.content = %q{
      fake article content

      foo
      ---
      
      bar}

    assert_equal BlueCloth.new(art.content).to_html, art.content_as_html
  end
end
