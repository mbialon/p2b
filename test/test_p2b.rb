require 'test/unit'
require 'p2b'

class Post2BloggerTest < Test::Unit::TestCase
  include Post2Blogger

  def test_should_return_help_command
    p2b = Post2Blogger.new
    cmd = p2b.parse(["help"])
    
    assert cmd.is_a? HelpCommand
  end

  def test_should_return_pull_command_id
    p2b = Post2Blogger.new
    cmd = p2b.parse(["pull"])
    
    assert cmd.is_a? PullCommand
  end
end
