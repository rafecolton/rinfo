# coding: utf-8

class RinfoController < ApplicationController
  include Rails.application.routes.url_helpers

  def info
    render json: Rinfo.info
  end
end
