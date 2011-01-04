require 'open-uri'

class WordSearcher 
	include ApplicationHelper
	def self.index
		@api  = IndexTank::Client.new(ENV['INDEXTANK_API_URL'] || 'http://:9sQ4eiUCEF+935@dw6hr.api.indextank.com')
	    @index ||= @api.indexes('idx')
        @index		
	end

	#retrieve words
	def self.search(query)
		query = removeunwanted(query)
		if (query.match(/^word:/)!=nil)
			match = query.match(/:(\w+)/)
			query = "searched_word:"+match[1]
			test = index.search(query, :fetch=>'searched_word,text')
			return test
		else
			puts "came here"
		    test = index.search(query, :fetch=>'searched_word,text', :snippet=>'text')
			puts "came here 1"
			test['results'].each do |n|
				puts n['text'].gsub(/\t/,'&nbsp;')
			end
			return test
		end
	end

	def self.removeunwanted(text)
		text = text.gsub(/[\[\]~!@#\$%\^&*\(\)\/\\]/,'')
		return text
	end
end
