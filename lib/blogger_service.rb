require 'net/http'
require 'uri'

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
  end

end
