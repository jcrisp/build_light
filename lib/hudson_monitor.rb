require 'net/http'
require 'uri'
require 'nokogiri'

class HudsonMonitor

  def initialize(url)
    @url = url
  end
  
  def rss
    Net::HTTP::get URI::parse(@url)
  end
  
  def check
    status = parse(rss)
    simplify(status)
  end
  
private
  
  def parse(rss)
    status = {}
    Nokogiri::XML(rss).css('title').each do |title|
      project, project_status = title.content.split(/#\d+/)
      status[project.strip] = project_status
    end
    status
  end
  
  def simplify(status)
    simplified = {}
    status.each do |project, project_status|
      simplified[project] = case project_status
      when /broken/; :red
      when /\?/; :yellow
      else :green
      end
    end
    simplified
  end
end