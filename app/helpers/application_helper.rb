module ApplicationHelper
	def addhighlights(text, textterms)
		textterms.split(/\s/).each do |n|
			text = text.gsub(/\b#{n}\b/i,"<b>#{n}</b>")
		end
		return text
	end
	def removechars(text)
		text = text.gsub(/[\[\]~!@#\$%\^&*\(\)\/\\]/,'')
		return text
	end

end
