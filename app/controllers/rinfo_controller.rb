# coding: utf-8

class RinfoController < ApplicationController
  include Rails.application.routes.url_helpers

  def info
    render json: Rinfo.inform!
  rescue
    redirect_to status: 404
  end
end
