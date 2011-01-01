require 'rubygems'
require 'nokogiri'
require 'open-uri'

#file = File.read(File.join())
file = File.new('/home/bhaarat/Downloads/output.txt', 'r')
out = File.new('allmeanings.txt', 'w')

while (line = file.gets)
word = ""
if (line.match(/^Wiktionary/) == nil and line.match(/^Appendix/) == nil and line.match(/^Category/) == nil and line.match(/^Index/) == nil)
	#word = line.gsub(/\n/,'')
	if (line.gsub(/\n/,'').match(/^[a-zA-Z-\s]+$/)!=nil)
		word = line.gsub(/\n/,'')
	end
	if (word.length > 0 and word.match(/\w+\s\w+/))
		word = word.gsub(/\s/,'_')
	end
end
out << word + "\n" 
puts word
if (word.length > 0)
link = "http://en.wiktionary.org/w/api.php?action=query&titles="+word.to_s+"&prop=revisions&rvprop=content&rvgeneratexml=&format=xml"
doc = Nokogiri::HTML(open(link, 'User-Agent'=>'ruby'))
node = doc.xpath('//pages/page')
pageid = node[0]['pageid']
type = []
word_meanings = []
if (pageid != nil) 
	doc = Nokogiri::HTML.parse(doc.xpath('//revisions/rev')[0]['parsetree'])
	doc.xpath('//root//template/title').each do |node|
		if (node.text.match(/^en-/))
			type << node.text.split(/-/)[1].capitalize if node.text.split(/=/)!=nil
		end
		if (node.text.match(/^acronym/))
			type << node.text.capitalize
		end
		if (node.text.match(/^abbreviation/))
			type << node.text.capitalize
		end
	end
else
	puts "word not found"
end
h = doc.xpath '//root/text()'
#puts type[0]
#puts type[1]
#puts type[2]
#puts
#puts
#puts
i = 0
j = 0
start = false

def is_quotation (line)
	#puts "line: #{line}"
	puts line.match(/^:/)!=nil
	return line.match(/^:/) != nil
end

def remove_junk (line)
	return_line = line.gsub(/[#\[\]\n]/,'')
	return return_line
end

def remove_junk_quote (line)
	return line.gsub(/[#\[\]\n':]/,'')
end

def not_needed_lines (line)
	return line.text.gsub(/\n/, '').match(/^[\w\*\\s(,]/)==nil 
end

def needed_lines (line)
	return (line.text.gsub(/\n/,'').match(/^# /) !=nil )#or line.text.gsub(/\n/,'').match(/^[\w\s]/) != nil)
end

def workable (line)
	return (line.text.match(/\n#/)) != nil
end

def otherWorkable (line)
	#puts "entered with:#{line.text.gsub(/\n/,'')}"
	#puts "returning"
	#puts line.text.gsub(/\n/,'').match(/^\s*\w/) != nil
	return (line.text.gsub(/\n/,'').match(/^\s*\w/) != nil)	
end

def is_quotation (line)
	#puts "line:#{line}"
	#puts "returning"
	#puts line.match(/^\*/) != nil
	line.match(/^\*/) != nil
end
continue = true
words_meanings = []
inside_hash = {}
text = ""
word = ""
h.each do |node|
	#text = ""
	inside_hash = {}
	if (node.text.match(/----/))
		node = node.text.gsub(/\n/,'').split(/----/)
		if (node.size > 0) 
			node.each do |n|
				if (n.length > 7 and words_meanings.size == 0)
					words_meanings << {:word => word, :meaning => n}
				end
			end
		end
		break;
	end
			#puts "original" + node
			#puts "start = " + start.to_s
			if (needed_lines(node) or start)  and (not_needed_lines(node))
				#puts "came here start = #{start} #{i}"
			#	puts "here "+node
				if (continue)
				#	puts type[j] if type[j] != nil
					#puts "----" if type[j] != nil
                    #parts_of_speech << type[j] if type[j] != nil
					word = type[j]+"\n" if type[j] != nil
					#puts word
					j = j+1
				end
				#if (type[j]!=nil)
				#	i = 0
					#words_meanings << {:word => word, :meaning => text}
				#	text = ""
				#end
				start = true
			 #   puts "start1 = " + start.to_s
				if (node.text.gsub(/\n/,'').length > 5)
				#		puts "inside if: #{node}"
						#if (node.text.match(/\b.\n#(\s+)\b/))
						#if (node.text.match(/\n#/)
						if (workable(node) && i <= 1)
				#			puts "here2: #{node.text}"
							#grab = node.text.split(/\b.\n#(\s+)\b/)
							grab = node.text.split(/\n#/)
							incr = false
							grab.each do |ele|
					#			puts "entered loop #{ele}"
								if (!is_quotation(remove_junk(ele)))
					#					puts "entered if"
										if ((remove_junk(ele).length > 2 && i <= 1) || remove_junk(ele).match(/^:/))
					#						puts "entered one if"
											if (remove_junk(ele).match(/^:/))
								#				puts "entered quote" + "\t\t" + remove_junk_quote(ele)
											    text = text + "\t\t" + remove_junk_quote(ele) + "\n"	
											else
								#				puts "entered else: #{remove_junk(ele)}"
												i = i+1
												#puts  remove_junk(ele)
												text = text + remove_junk(ele) + "\n"
											end 
										end
								end
								
							end
						elsif (!workable(node) && i <= 1 && otherWorkable(node))
								grab = node.text.gsub(/\n/,'').split(/#:/)
								#puts "in else: " + grab[0].gsub(/[\[\]\'#]/,'')
								text += grab[0].gsub(/[\[\]'#]/,'')
								i = i + 1
								#puts "in else: " + "\t\t\t#{grab[1].gsub(/[#']/,'')}" if (grab[1] != nil and grab[1].match(/http/) == nil)
								text += "\t\t\t#{grab[1].gsub(/[#']/,'')}" if (grab[1] != nil and grab[1].match(/http/) == nil)

						end
				end
				if (node.text.chop.match(/\#$/))
					continue = false
				end
				#puts "i = #{i}"
				#puts "start = #{start}"
				#puts "continue = #{continue}"
				#puts text
				#puts "here: #{word}"
			    if (i==2)
					start = false
					i = 0
					continue = true
					#puts "got two so inserting"
					words_meanings << {:word => word, :meaning => text}
					text = ""
				end
				if (i == 1 and continue)
					#puts "interesting if"
					#words_meanings << {:word => word, :meaning => text}
				end
				if (node.text.match(/\n\n$/) and i > 0)
					#puts "last line so inserting"
					words_meanings << {:word => word, :meaning => text}
					text = ""
					i = 0
					continue = true
				end
			else
				if (i > 0)
						start = false
						continue = true	
						if (i > 0)
			#				    puts "Reached Seperator so inserting here"
				#				words_meanings << {:word => word, :meaning => text}
								text = ""
						end
						i = 0
				end
				#puts "came in else: " +  node
			end
end
if (i == 1 and words_meanings.size == 0) 
	words_meanings << {:word => word, :meaning => text}
end
words_meanings.each do |word|
	out << word[:word] + "\n"
	out << word[:meaning] + "\n"
end
end #end if
end