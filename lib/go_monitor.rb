require 'net/http'
require 'uri'
require 'nokogiri'

class GoMonitor
  def initialize(urlstring)
    @url = URI.parse(urlstring)
  end

  def rss
    # TODO: Display something indicating infrastructure failure if the connection doesn't happen
    Net::HTTP.start(@url.host, @url.port) do |http|
      req = Net::HTTP::Get.new(@url.path)
      req.basic_auth @url.user, @url.password
      http.request(req)
    end.body
  end

  def check
    status = parse(rss)
  end

  private

  def parse(rss)
    status = {}
    Nokogiri::XML(rss).css('Project').each do |projectline|
      status.merge!(parseSingle(projectline))
    end
    status
  end

  def parseSingle(projectline)
    single = {}
    single[projectline[:name]] =
        if projectline[:activity] == 'Sleeping' && projectline[:lastBuildStatus] == 'Success'
          :green
        elsif projectline[:activity] == 'Building'
          :yellow
        else
          :red
        end
    single
  end
end
