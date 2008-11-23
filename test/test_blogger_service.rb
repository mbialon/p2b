require 'test/unit'
require 'net/http'
require 'uri'
require 'blogger_service'

class BloggerServiceTest < Test::Unit::TestCase
  include Post2Blogger

  def test_should_require_login_and_password
    svc = BloggerService.new('fake_email', 'fake_password')

    assert_equal 'fake_email', svc.email
    assert_equal 'fake_password', svc.password
  end

  def test_should_login_to_blogger_service
    url = URI.parse("https://www.google.com/accounts/ClientLogin")
    http = mock()
    Net::HTTP.expects(:new).with(url.host, url.port).returns(http)
    http.expects(:use_ssl=).with(true)
    resp = mock()
    resp.expects(:is_a?).with(Net::HTTPOK).returns(true)
    resp.expects(:body).returns(%q{
SID=foo
LSID=bar
Auth=blah})
    http.expects(:start).yields(http).returns(resp)
    http.expects(:request)

    svc = BloggerService.new('fake_email', 'fake_password')
    assert svc.login!
    assert_equal 'foo', svc.sid
    assert_equal 'bar', svc.lsid
    assert_equal 'blah', svc.auth
  end
end
