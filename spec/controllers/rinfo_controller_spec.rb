# coding: utf-8

require 'tmpdir'
require 'git'

describe RinfoController, type: :controller do
  before :all do
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

  after :all do
    Dir.chdir(Rails.root)
    FileUtils.rm_rf(@tmpdir)
  end

  let(:author) { @name }
  let(:deploy_time) { "#{@date}" }
  let(:rails_env) { 'test' }
  let(:branch) { @branch_name }
  let(:rev) { @rev }

  let(:rinfo) do
    <<-RINFO.gsub(/^ {4}/, '')
    {
      "Deployed By": "#{author}",
      "Deployed At": "#{deploy_time}",
      "Rails Env": "#{rails_env}",
      "Branch": "#{branch}",
      "Rev": "#{rev}"
    }
    RINFO
  end

  describe 'GET #info' do
    it 'renders rinfo.json' do
      Rinfo.stub(:root).and_return(@tmpdir)

      get 'info', format: :json
      response.body.should == rinfo
    end
  end
end
