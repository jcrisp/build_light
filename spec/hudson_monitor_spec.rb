require "spec_helper"
require 'lib/hudson_monitor'

describe HudsonMonitor do
  subject { HudsonMonitor.new 'http://fake.hudson.com/rssLatest.xml' }

  it 'it should return simplified project status from rss feed' do
    rss = %{
      <feed>
        <entry>
          <title>Project 1 #1 (back to normal)</title>
        </entry>
        <entry>
          <title>Project 2 #2 (?)</title>
        </entry>
        <entry>
          <title>Project 3 #3 (broken)</title>
        </entry>
      </feed>
    }
    subject.stub!(:rss).and_return(rss)
    subject.check.should == {
      'Project 1' => :green,
      'Project 2' => :yellow,
      'Project 3' => :red
    }
  end
end