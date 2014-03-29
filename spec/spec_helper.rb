# coding: utf-8

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rails'
require 'rubygems'
require 'bundler/setup'
require 'pry' unless RUBY_PLATFORM == 'java'
require 'rspec/rails'
require 'rspec/autorun'
require 'simplecov'
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start
SimpleCov.start 'rails'
