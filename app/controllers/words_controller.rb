class WordsController < ApplicationController
	def index
		@docs = WordSearcher.search(params[:query]) if params[:query].present?
	end
end
