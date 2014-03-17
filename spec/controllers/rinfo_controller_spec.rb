# coding: utf-8

require 'tmpdir'
require 'git'

describe RinfoController, type: :controller do
  before(:all) do
    # create temporary directory
    @tmpdir = Dir.mktmpdir
    Dir.chdir(@tmpdir)

    # initialize a git repository
    git = Git.init(Dir.pwd)
    FileUtils.touch("#{Dir.pwd}/initial-file.txt")
    @name = 'Spec Ninja'
    git.config('user.name', @name)
    git.config('user.email', 'spec_ninja@example.com')
    git.add
    git.commit('initial commit')

    # checkout our desired branch
    @branch_name = 'foo-bar-branch'
    git.branch(@branch_name).checkout

    # set the other things we're checking for
    @rev = git.revparse('HEAD')
    @date = git.log.first.date
  end

  before(:each) do
    Rinfo.stub(:root).and_return(@tmpdir)
  end

  after(:all) do
    Dir.chdir(Rails.root)
    FileUtils.rm_rf(@tmpdir)
  end

  let(:author) { @name }
  let(:deploy_time) { "#{@date}" }
  let(:rails_env) { 'test' }
  let(:branch) { @branch_name }
  let(:rev) { @rev }

  let(:rinfo) do
  end

  def rinfo
    <<-RINFO.gsub(/^ {4}/, '')
    {
      "Deployed By": "#{author}",
      "Deployed At": "#{deploy_time}",
      "Rails Env": "#{Rinfo.send(:env)}",
      "Branch": "#{branch}",
      "Rev": "#{rev}"
    }
    RINFO
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
          get 'info', format: :json
          response.status.should == 404
        end
      end

      it 'displays rinfo for all envs not on the blacklist' do
        default_whitelist.each do |env|
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
          Rinfo.stub(:env).and_return(env.to_s)
          get 'info', format: :json
          response.status.should == 404
        end
      end
    end

    context 'custom blacklist' do
      before(:each) do
        Rinfo.stub(:env_blacklist).and_return(custom_blacklist)
      end

      it 'does not display rinfo for blacklisted envs' do
        custom_blacklist.each do |env|
          Rinfo.stub(:env).and_return(env.to_s)
          get 'info', format: :json
          response.status.should == 404
        end
      end

      it 'displays rinfo for non-blacklisted envs' do
        (rails_envs - custom_blacklist).each do |env|
          Rinfo.stub(:env).and_return(env.to_s)
          get 'info', format: :json
          response.body.should == rinfo
        end
      end
    end
  end
end
