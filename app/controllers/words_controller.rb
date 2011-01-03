class WordsController < ApplicationController
	def index
		@docs = WordSearcher.search(params[:query]) if params[:query].present?
		@recent_searches = REDIS.lrange("wiki", -10, -1)
		if @docs
			REDIS.rpush("wiki", params[:query])
			REDIS.ltrim("wiki", -10, -1)
		end
	end
end
