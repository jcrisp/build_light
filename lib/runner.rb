class Runner
  attr_reader :checks
  attr_accessor :delay

  def initialize
    @checks = 0
    @delay = 3
    @monitor_light_pairs = {}
  end

  def add_monitor_light_pair(monitor, light)
    current_lights = @monitor_light_pairs[monitor] || []
    @monitor_light_pairs[monitor] = current_lights << light
  end

  def start
    trap 'SIGINT' do
      all_lights.each do |light|
        light.off
        light.close
      end
      exit!
    end

    all_lights.each do |light|
      puts light.identify
    end

    until finished
      begin
        @monitor_light_pairs.each do |monitor, lights|
          status = monitor.check
          lights.each do |light|
            light.status = status
          end
        end
      rescue Exception => e
        puts e.inspect
        puts e.backtrace
        # keep running
      ensure
        @checks += 1
        sleep @delay
      end
    end
  end

  def all_lights
    all_mentioned_lights = []
    @monitor_light_pairs.each do |monitor, lights|
      all_mentioned_lights.concat lights
    end
    all_mentioned_lights
  end

  def finished
    false
  end
end