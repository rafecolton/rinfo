# coding: utf-8

require 'rinfo/engine'
require 'rinfo/cache'
require 'git'
require 'time'

class Rinfo
  autoload :VERSION, 'rinfo/version'

  class << self
    attr_writer :filename

    def inform!
      if should_inform?
        JSON.pretty_generate(rinfo)
      else
        fail ActionController::RoutingError, 'Not Found'
      end
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

    def filename
      @filename ||= 'rinfo.json'
    end

    private

    def rinfo
      {
        deployed_by: author,
        deployed_at: date,
        rails_env: env,
        branch: branch,
        rev: rev
      }
    end

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
      name = git.config('user.name')
      name.blank? ? git.log.first.author.name : name
    end

    def date
      git.log.first.date.iso8601
    end

    def branch
      git.lib.branch_current
    end

    def rev
      git.revparse('HEAD')
    end
  end
end
