# coding: utf-8

require 'rinfo/engine'
require 'git'

class Rinfo
  autoload :VERSION, 'rinfo/version'

  class << self
    def info
      <<-RINFO.gsub(/^ {6}/, '')
      {
        "Deployed By": "#{author}",
        "Deployed At": "#{date}",
        "Rails Env": "#{Rails.env}",
        "Branch": "#{branch}",
        "Rev": "#{rev}"
      }
      RINFO
    end

    private

    def git
      @git ||= Git.open(root)
    end

    def root
      Rails.root
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
