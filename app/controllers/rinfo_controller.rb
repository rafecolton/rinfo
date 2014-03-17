# coding: utf-8

class RinfoController < ApplicationController
  include Rails.application.routes.url_helpers

  respond_to :json

  def info
    respond_to do |format|
      format.json { render json: Rinfo.info }
    end
  end
end
