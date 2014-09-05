class SweetsController < InheritedResources::Base
  respond_to :json
	def index
		respond_with "hey"
	end

end
