require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'HTTParty'

urls = []
file = File.new("data.txt", "r")
while (line = file.gets)
  urls << line.chomp
end
file.close

count = 1
urls.each do |url|
  begin
    doc = Nokogiri.parse(open(url).read)
    node = doc.xpath("//dt/a[text()='Download video to desktop (MP4)']")
    video = "http://www.ted.com" + node.attribute("href").to_s
    videoName = "videos/(#{count})" + url.match(/http:\/\/www.ted.com\/talks\/(.*)\.html/i)[1] + ".mp4"
    puts "Downloading #{url} to #{videoName}"

    File.open( videoName, "w+") do |f|
      f << HTTParty.get( video ) 
    end
  rescue
    puts "Failed to download #{url}"
  end
  count += 1
end