require 'rubygems'
require 'mechanize'
require 'logger'
require 'nokogiri'
require 'pp'


$domain_root = 'http://www.alahazrat.net'
$base_url = 'http://www.alahazrat.net/alquran/Quran/index.html'
$content_base_url = 'http://www.alahazrat.net/alquran/Quran/'

# rootDir = ARGV[0]
# 
# Dir.mkdir(rootDir) if not File.directory?(rootDir)
# Dir.chdir(rootDir)
# 
$logger = Logger.new('kanzulscript.rb.log')
output = File.open('kanzuloutput.txt', 'w')


class String
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
  def numeric?
      Float(self) != nil rescue false
  end
end

# 
# class BookItem
#   attr_accessor :subject
#   attr_accessor :year
#   attr_accessor :bar_code
#   attr_accessor :pages
#   attr_accessor :title
#   attr_accessor :metadata_link
#   attr_accessor :content_link
#   attr_accessor :first_page
#   attr_accessor :last_page
#   attr_accessor :content_path
#   
#   def initialize(subject=nil, year=nil, bar_code=nil, pages=nil, title=nil, metadata_link=nil)
#     @subject = subject
#     @year = year
#     @bar_code = bar_code
#     @pages = pages
#     @title = title
#     @metadata_link = metadata_link
#   end
#   
# end
# 
# 
# def parseLink(link)
#   book = BookItem.new  
#   tokens = link.split('&')
#   tokens.each { |token|
#     parts = token.split('=')
#     
#     book.subject = parts[1].to_s.strip if parts[0] == 'subject1'
#     book.year = parts[1].to_s.strip if parts[0] == 'year'
#     book.bar_code = parts[1].to_s.strip if parts[0] == 'barcode'
#     book.pages = parts[1].to_s.strip.to_i if parts[0] == 'pages'
#     book.title = parts[1].to_s.strip if parts[0] == 'title1'
#     book.content_path = parts[1].to_s.strip if parts[0] == 'url'
#   }
# 
#   book.first_page = 1
#   book.last_page = book.pages
#   book.metadata_link = link
#   
#   return book  
# end
# 
# def get_page_name(page)
#   page.to_s.rjust(8, '0')
# end
# 
# def get_page_name_with_extension(page)
#   get_page_name(page) + '.tif'
# end
# 
# def get_page_url(book, page)
#   $domainRoot + book.content_path + '/PTIFF/' + get_page_name_with_extension(page)
# end
# 
# def get_group_dir_name(start, ending)
#   start.to_s + '-' + ending.to_s
# end
# 
# def save_book(book, file)
#   file.puts "Title=#{book.title}"
#   file.puts "Barcode=#{book.bar_code}"
#   file.puts "Pages=#{book.pages.to_s}"
#   file.puts "Subject=#{book.subject}"
#   file.puts "Year=#{book.year}"
#   file.puts "Content-Path=#{book.content_path}"
#   file.puts "First-Page=#{book.first_page}"
#   file.puts "Last-Page=#{book.last_page}"
#   file.puts "Metadata-Link=#{book.metadata_link}"
# end

def parse_link(link)
  surah, aya_range = link.split('/')
  aya_range, ext = aya_range.split('.')
  surah, aya_start, aya_end = aya_range.split('_')
  return surah, aya_start, aya_end
end

para = {}
mechanize = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
  agent.log = $logger
}

surah_ayah_count = [0,7,286,200,176,120,165,206,75,129,109,123,111,43,52,99,128,111,110,98,
										135,112,78,118,64,77,227,93,88,69,60,34,30,73,54,45,83,182,88,75,85,54,
										53,89,59,37,35,38,29,18,45,60,49,62,55,78,96,29,22,24,13,14,11,11,18,12,
										12,30,52,52,44,28,28,20,56,40,31,50,40,46,42,29,19,36,25,22,17,19,26,30,
										20,15,21,11,8,8,19,5,8,8,11,11,8,3,9,5,4,7,3,6,3,5,4,5,6]

open('/Volumes/Mac/Users/usmanghani/Downloads/en.ahmedraza.trans/en.ahmedraza.txt') do |file|
  (1..114).each do |index|
    puts surah_ayah_count[index]
    surah_ayah_count[index].times do |times|
      puts file.readline
    end   
  end
end

# index_page = mechanize.get($base_url)
# index_page.links.each { |link|
#   
#   if (link.href.split('/')[0].numeric?) then
#     $logger.info(link.href)
#     surah, aya_start, aya_end = parse_link(link.href) 
#     $logger.info("Surah => #{surah}, Aya_Start => #{aya_start}, Aya_End => #{aya_end}")
#     
#     # content_page_link = "#{$content_base_url}#{link.href}"
#     content_page_link = 'http://www.alahazrat.net/alquran/Quran/004/004_007_011.html'
#     $logger.info(content_page_link)
# 
#     content_page = mechanize.get(content_page_link)
#     
#     content_doc = Nokogiri::HTML(content_page.body)
#     rows = content_doc.xpath('//table[@width="99%"]/tr')
#     rows.collect do |row|
#       paras = row.xpath('td[2]/p')
#       paras.collect do |para|
#         trans = para.at_xpath('font/font/text()').to_s.strip
#         if trans.empty? then
#           trans = para.to_s.strip.gsub(/<span class="SpellE">(.*?)<\/span>/, '\1')
#           trans = trans.gsub(/<p class="MsoNormal" dir="ltr">.*<font.*?>(.*?)<\/font>.*/m, '\1')
#         end
#         puts trans
#         output.puts trans
#       end
#       break  
#     end
#     break
#   end
#   
# }

# (0..2000).step(20).each { |index|
#   group_dir_name = get_group_dir_name(index, index + 20)
#   Dir.mkdir(group_dir_name) if not File.directory?(group_dir_name)
#   Dir.chdir(group_dir_name)
#   
#   items_list_page = mechanize.get($baseUrl % [index, 20])
#   books = []
#   items_list_page.links.each { |link|
#     book = parseLink(link.href) if link.href.starts_with?('metainfo.cgi')
#     books.push(book)
#   }    
#   
#   books.each { |book|
#     Dir.mkdir book.bar_code if not File.directory? book.bar_code
#     Dir.chdir(book.bar_code)
#     
#     File.open('.meta', 'w+') { |file| save_book(book, file) }
#     
#     (book.first_page .. book.last_page).each { |page|
#       page_url = get_page_url(book, page)
#       begin
#         $logger.info 'Downloading %s' % page_url
#         if not File.exists?(get_page_name_with_extension(page))
#           mechanize.get(page_url).save()
#         else
#           $logger.info 'Skipping download of already existing file %s' % get_page_name_with_extension(page)
#         end
#       rescue
#         $logger.error 'Failed to download %s' % page_url
#       end
#     }
#   }
# }
