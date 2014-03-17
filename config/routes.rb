# coding: utf-8

Rails.application.routes.draw do
  get '/rinfo.json', to: 'rinfo#info', format: 'json'
end
