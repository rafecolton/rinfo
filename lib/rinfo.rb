# coding: utf-8

require 'rinfo/engine'
require 'git'
require 'action_controller'

class Rinfo
  autoload :VERSION, 'rinfo/version'

  class << self
    def inform!
      fail ActionController::RoutingError 'Not Found' unless should_inform?
      <<-RINFO.gsub(/^ {6}/, '')
      {
        "Deployed By": "#{author}",
        "Deployed At": "#{date}",
        "Rails Env": "#{env}",
        "Branch": "#{branch}",
        "Rev": "#{rev}"
      }
      RINFO
    end

    def should_inform?
      ([:all, env.to_sym] & env_blacklist).empty?
    end

    def env_blacklist
      @env_blacklist ||= [:prod, :production]
    end

    def env_blacklist=(args)
      @env_blacklist = [*args].map(&:to_sym)
    end

    private

    def git
      @git ||= Git.open(root)
    end

    def root
      Rails.root
    end

    def env
      Rails.env
    end

    def author
      git.config('user.name')
    end

    def date
      git.log.first.date
    end

    def branch
      git.lib.branch_current
    end

    def rev
      git.revparse('HEAD')
    end
  end
end
