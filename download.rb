require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'httparty'

urls = IO.readlines("data.txt").map {|line| line.chomp}
if !File.exists?("videos")
  Dir.mkdir("videos")
end

urls.each_with_index do |url, count|
  begin
    doc = Nokogiri.parse(open(url).read)
    node = doc.xpath("//dt/a[text()='Download video to desktop (MP4)']")
    video = "http://www.ted.com" + node.attribute("href").to_s
    videoName = "videos/(#{count+1})" + url.match(/http:\/\/www.ted.com\/talks\/(.*)\.html/i)[1] + ".mp4"
    puts "Downloading #{url} to #{videoName}"

    File.open( videoName, "w+") do |f|
      f << HTTParty.get( video ) 
    end
  rescue
    puts "Failed to download #{url}"
  end
end
