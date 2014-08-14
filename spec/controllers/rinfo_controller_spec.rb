# coding: utf-8

require 'tmpdir'
require 'git'
require 'time'

describe RinfoController, type: :controller do
  before(:all) do
    # create temporary directory
    @tmpdir = Dir.mktmpdir
    Dir.chdir(@tmpdir)

    # initialize a git repository
    @git = Git.init(Dir.pwd)
    FileUtils.touch("#{Dir.pwd}/initial-file.txt")
    @name = 'Spec Ninja'
    @git.config('user.name', @name)
    @git.config('user.email', 'spec_ninja@example.com')
    @git.add
    @git.commit('initial commit')

    # checkout our desired branch
    @branch_name = 'foo-bar-branch'
    @git.branch(@branch_name).checkout

    # set the other things we're checking for
    @rev = @git.revparse('HEAD')
    @date = @git.log.first.date
  end

  before(:each) do
    ::MemoryCache.instance.clear
    Rinfo.stub(:root).and_return(@tmpdir)
  end

  after(:all) do
    Dir.chdir(Rails.root)
    FileUtils.rm_rf(@tmpdir)
  end

  let(:author) { @name }
  let(:deploy_time) { "#{@date.iso8601}" }
  let(:rails_env) { 'test' }
  let(:branch) { @branch_name }
  let(:rev) { @rev }

  let(:rinfo) do
  end

  def rinfo
    JSON.pretty_generate(
      deployed_by: author,
      deployed_at: deploy_time,
      rails_env: "#{Rinfo.send(:env)}",
      branch: branch,
      rev: rev
    )
  end

  describe 'GET #info' do
    let(:rails_envs) do
      %w(test development demo stage staging prod production).map(&:to_sym)
    end
    let(:default_blacklist) { [:prod, :production] }
    let(:default_whitelist) do
      %w(test development demo stage staging).map(&:to_sym)
    end
    let(:custom_blacklist) { [:demo, :stage] }
    let(:blacklist_allow_all) { [:none] }
    let(:blacklist_allow_none) { [:all] }

    context 'default blacklisted envs' do
      it 'does not display rinfo for blacklisted envs' do
        default_blacklist.each do |env|
          Rinfo.stub(:env).and_return(env.to_s)
          expect { get 'info', format: :json }.to raise_error(
            ActionController::RoutingError
          )
        end
      end

      it 'displays rinfo for all envs not on the blacklist' do
        default_whitelist.each do |env|
          ::MemoryCache.instance.clear
          Rinfo.stub(:env).and_return(env.to_s)
          get 'info', format: :json
          response.body.should == rinfo
        end
      end
    end

    context 'all envs enabled' do
      before(:each) do
        Rinfo.stub(:env_blacklist).and_return(blacklist_allow_all)
      end

      it 'displays rinfo for all envs' do
        rails_envs.each do |env|
          ::MemoryCache.instance.clear
          Rinfo.stub(:env).and_return(env.to_s)
          get 'info', format: :json
          response.body.should == rinfo
        end
      end
    end

    context 'all envs disabled' do
      before(:each) do
        Rinfo.stub(:env_blacklist).and_return blacklist_allow_none
      end

      it 'does not display rinfo for any envs' do
        rails_envs.each do |env|
          ::MemoryCache.instance.clear
          Rinfo.stub(:env).and_return(env.to_s)
          expect { get 'info', format: :json }.to raise_error(
            ActionController::RoutingError
          )
        end
      end
    end

    context 'custom blacklist' do
      before(:each) do
        Rinfo.stub(:env_blacklist).and_return(custom_blacklist)
      end

      it 'does not display rinfo for blacklisted envs' do
        custom_blacklist.each do |env|
          ::MemoryCache.instance.clear
          Rinfo.stub(:env).and_return(env.to_s)
          expect { get 'info', format: :json }.to raise_error(
            ActionController::RoutingError
          )
        end
      end

      it 'displays rinfo for non-blacklisted envs' do
        (rails_envs - custom_blacklist).each do |env|
          ::MemoryCache.instance.clear
          Rinfo.stub(:env).and_return(env.to_s)
          get 'info', format: :json
          response.body.should == rinfo
        end
      end
    end

    context 'git config user.name is blank' do
      before(:each) { @git.config('user.name', '') }
      after(:each) { @git.config('user.name', @name) }

      it 'displays the author name on the last commit' do
        get 'info', format: :json
        response.body.should == rinfo
      end
    end
  end
end
