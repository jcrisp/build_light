require "spec_helper"
require "lib/runner"
require "lib/hudson_monitor"
require "lib/stdout_light"

describe Runner do
  before :each do
    subject.delay = 0
  end
  
  it 'should check and set status until finished' do
    monitor = HudsonMonitor.new('http://fake.hudson.com/rssLatest')
    light = StdoutLight.new('test light')
    subject.add_monitor_light_pair(monitor, light)

    subject.stub!(:finished).and_return do
      subject.checks == 3
    end

    monitor.should_receive(:check).exactly(3).times.and_return('status')
    light.should_receive(:status=).with('status').exactly(3).times
    subject.start
  end
  
  it 'should keep running on error' do
    monitor = HudsonMonitor.new('http://fake.hudson.com/rssLatest')
    light = StdoutLight.new('test light')
    subject.add_monitor_light_pair(monitor, light)

    subject.stub!(:finished).and_return do
      subject.checks == 3
    end

    monitor.stub!(:check).and_raise('an error')

    puts "The errors immediately below are expected by the test"
    puts "====================================================="
    subject.start
    subject.checks.should == 3

    puts "====================================================="
    puts "The errors immediately above are expected by the test"

  end
end