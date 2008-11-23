# p2b init $blogId - creates config file inside current dir
# p2b pull - fetches all the articles from a blog and saves them into files
# p2b push $filename - uploads article to a blog
# p2b help - lists available commands

module Post2Blogger

  class Post2Blogger
    def parse(args = [])
      cmd = args[0]
      if "help".eql? cmd
        HelpCommand.new
      elsif "pull".eql? cmd
        PullCommand.new
      else
        nil
      end
    end
  end

  module Command
    def exec
    end
  end

  class HelpCommand
    include Command

    def exec
      # p2b init $blogId - creates config file inside current dir
      # p2b pull - fetches all the articles from a blog and saves them into files
      # p2b push $filename - uploads article to a blog
      puts "p2b help ;; lists available commands"
    end
  end

  class PullCommand
    include Command

    def exec
    end
  end
end
