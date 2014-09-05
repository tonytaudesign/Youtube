class Sweet < ActiveRecord::Base
	  respond_to :json

	  def index
	  	respond_with "Hey"
	  end
end
