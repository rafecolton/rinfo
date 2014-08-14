# coding: utf-8

class RinfoController < ApplicationController
  include Rails.application.routes.url_helpers

  def info
    json_data = ::MemoryCache.instance.fetch('rinfo_data') do
      Rinfo.inform!
    end
    render json: json_data
  end
end
