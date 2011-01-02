require 'open-uri'

class WordSearcher 
	def self.index
		@api  = IndexTank::Client.new(ENV['INDEXTANK_API_URL'] || 'http://:9sQ4eiUCEF+935@dw6hr.api.indextank.com')
	    @index ||= @api.indexes('idx')
        @index		
	end

	#retrieve words
	def self.search(query)
		if (query.match(/^word:/)!=nil)
			match = query.match(/:(\w+)/)
			query = "searched_word:"+match[1]
			test = index.search(query, :fetch=>'searched_word,text')
			return test
		else
		    test = index.search(query, :fetch=>'searched_word,text', :snippet=>'text')
			test['results'].each do |n|
				puts n['text'].gsub(/\t/,'&nbsp;')
			end
			return test
		end
	end

end
