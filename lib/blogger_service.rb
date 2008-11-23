require 'net/https'
require 'uri'
require 'rubygems'
require 'atom/pub'

module Post2Blogger

  class BloggerService
    attr_reader :email, :password
    attr_reader :sid, :lsid, :auth

    def initialize(email, password)
      @email, @password = email, password
    end

    def login!
      url = URI.parse("https://www.google.com/accounts/ClientLogin")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      resp = http.start do |h|
        req = Net::HTTP::Post.new(url.path)
        req.set_form_data({'Email' => email,
                            'Passwd' => password,
                            'service' => 'blogger',
                            'accountType' => 'GOOGLE',
                            'source' => 'test-app-1'})
        h.request(req)
      end
      if resp.is_a? Net::HTTPOK
        re = /^(.*)=(.*)/
        resp.body.each_line do |line|
          m = re.match(line)
          if m
            case m[1]
              when "SID" : @sid = m[2]
              when "LSID" : @lsid = m[2]
              when "Auth" : @auth = m[2]
            end
          end
        end
        true
      else
        false
      end
    end

    def logged_in?
      auth
    end

    def push(article)
      entry = Atom::Entry.new do |e|
        e.title = article.title
        html = ''
        article.content_as_html.each_line { |line| html += line.chomp }
        e.content = Atom::Content::Html.new(html)
        e.categories = article.categories.map do |name|
          Atom::Category.new do |cat| 
            cat.term = name
            cat.scheme = 'http://www.blogger.com/atom/ns#'
          end
        end
      end

      puts entry.to_xml

      url = URI.parse("http://www.blogger.com/feeds/#{article.blog_id}/posts/default")
      http = Net::HTTP.new(url.host, url.port)
      resp = http.start do |h|
        req = Net::HTTP::Post.new(url.path, { "Authorization" => "GoogleLogin auth=#{auth}",
                                    "Content-Type" => "application/atom+xml" })
        req.body = entry.to_xml

        h.request(req)
      end
      if resp.is_a? Net::HTTPCreated
        true
      else
        puts resp
        false
      end
    end
  end

end
