# coding: utf-8

Rails.application.routes.draw do
  get "/#{Rinfo.filename}", to: 'rinfo#info'
end
