class FuckeryController < ApplicationController
    respond_to :json
  def new
  	hash = {yacht: "ALL DAY"}
  	respond_with hash
  end
end
