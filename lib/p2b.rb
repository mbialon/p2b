# p2b init $blogId - creates config file inside current dir
# p2b pull - fetches all the articles from a blog and saves them into files
# p2b push $filename - uploads article to a blog
# p2b help - lists available commands

require 'blogger_service'
require 'article'

module Post2Blogger

  class Post2Blogger
    def parse(args = [])
      def args.head
        self[0]
      end
      def args.tail
        self[1..size]
      end

      cmd = if PushCommand.is?(args.head)
              PushCommand.new(args.tail)
            else
              nil
            end
      cmd
    end

    def invoke(args)
      cmd = parse(args)
      cmd.execute()
    end
  end

  class PushCommand
    attr_reader :filename, :email, :password

    def self.is?(cmd)
      "push".eql? cmd
    end

    def initialize(args)
      @filename = args[0]
      @email = args[1]
      @password = args[2]
    end

    def execute
      svc = BloggerService.new(email, password)
      puts "not logged in" unless svc.login!
      if (svc.logged_in? && svc.push(Article.from_file(filename)))
        puts "ok"
      else
        puts "failed"
      end
    end
  end
end

p = Post2Blogger::Post2Blogger.new
p.invoke(ARGV)
