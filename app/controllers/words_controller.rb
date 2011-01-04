class WordsController < ApplicationController
	include ApplicationHelper
	def index
		@docs = WordSearcher.search(params[:query]) if params[:query].present? and removechars(params[:query]).length > 0
		@recent_searches = REDIS.lrange("wiki", -10, -1)
		if @docs
			REDIS.rpush("wiki", removechars(params[:query]))
			REDIS.ltrim("wiki", -10, -1)
		end
	end
end
