class StdoutLight
  attr_accessor :projects

  def self.devices
    (1..10).map { |num| "light#{num}"}
  end

  def initialize(name)
    @name = name
  end

  def status=(status)
    red, yellow = false, false
    filtered(status).each do |project, project_status|
      case project_status
      when :red; red = true
      when :yellow; yellow = true
      end
    end
    if yellow; yellow(); return; end
    if red; red(); return; end
    if projects == nil || projects.all? { |p| status.keys.include? p }
      green()
    else
      # fail to red if a project you are looking for isn't found in status
      red()
    end
  end

  def identify
    "i'm light #{@name}"
  end

  def red
    puts "#{@name}: red"
  end

  def green
    puts "#{@name}: green"
  end

  def yellow
    puts "#{@name}: yellow"
  end

  def off
    puts "#{@name}: off"
  end

  def close
    puts "#{@name}: close"
  end

private

  def filtered(status)
    return status unless projects
    status.reject do |project, project_status|
      not projects.include? project
    end
  end
end
