# coding: utf-8

Rails.application.routes.draw do
  get "/#{Rinfo.filename}.#{Rinfo.filetype}", to: 'rinfo#info'
end
