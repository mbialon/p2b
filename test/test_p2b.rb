require 'test/unit'
require 'p2b'
require 'article'
require 'blogger_service'

class Post2BloggerTest < Test::Unit::TestCase
  include Post2Blogger

  def test_should_return_push_command
    p2b = Post2Blogger.new
    cmd = p2b.parse(["push", "foo"])
    
    assert cmd.is_a? PushCommand
  end

  def test_should_invoke_command
    args = ["push", "foo"]
    fake_cmd = mock()
    fake_cmd.expects(:execute)

    p2b = Post2Blogger.new
    p2b.expects(:parse).with(args).returns(fake_cmd)

    p2b.invoke(args)
  end
end

class PushCommandTest < Test::Unit::TestCase
  include Post2Blogger

  def test_should_state_its_a_push_command
    assert PushCommand.is?("push")
  end

  def test_should_stats_its_not_a_push_command
    assert !PushCommand.is?("pull")
  end

  def test_should_find_filename_in_args
    cmd = PushCommand.new(["foo"])
    assert cmd.filename, "foo"
  end

  def test_should_execute_command
    filename = "foo"
    email = "fake_email"
    passwd = "fake_passwd"
    cmd = PushCommand.new([filename, email, passwd])
    
    article = mock()
    Article.expects(:from_file).with(filename).returns(article)

    service = mock()
    BloggerService.expects(:new).with(email, passwd).returns(service)
    service.expects(:login!).returns(true)
    service.expects(:logged_in?).returns(true)
    service.expects(:push).with(article)

    cmd.execute
  end
end
