# p2b init $blogId - creates config file inside current dir
# p2b pull - fetches all the articles from a blog and saves them into files
# p2b push $filename - uploads article to a blog
# p2b help - lists available commands

require 'blogger_service'

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
    def self.is?(cmd)
      "push".eql? cmd
    end

    def initialize(args)
      @filename = args[0]
    end

    def filename
      @filename
    end

    def execute
      article = Article.from_file(filename())
      blogger = BloggerService.new
      blogger.push(article)
    end
  end
end
