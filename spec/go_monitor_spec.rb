require "spec_helper"
require "lib/go_monitor"

describe GoMonitor do
  subject { GoMonitor.new('http://fake.go.nbnco.local/go/cctray.xml') }

  it "should return simplified project status from cctray.xml file" do
    rss = %{
<?xml version="1.0" encoding="utf-8"?>
<Projects>
  <Project name="Addressing :: fullbuild" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="1.17" lastBuildTime="2011-04-08T11:12:25" webUrl="http://192.168.105.28:8153/go/pipelines/Addressing/17/fullbuild/1" />
  <Project name="Addressing :: package" activity="Building" lastBuildStatus="Success" lastBuildLabel="1.17" lastBuildTime="2011-04-08T11:13:04" webUrl="http://192.168.105.28:8153/go/pipelines/Addressing/17/package/1" />
  <Project name="Addressing :: Publish" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="1.17" lastBuildTime="2011-04-08T11:13:47" webUrl="http://192.168.105.28:8153/go/pipelines/Addressing/17/Publish/1" />
  <Project name="OnlineCustomers :: UnitTest" activity="Sleeping" lastBuildStatus="Wibble" lastBuildLabel="1.385" lastBuildTime="2011-04-11T18:27:10" webUrl="http://192.168.105.28:8153/go/pipelines/OnlineCustomers/385/UnitTest/1" />
  <Project name="OnlineCustomers :: Publish" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="1.385" lastBuildTime="2011-04-11T18:27:41" webUrl="http://192.168.105.28:8153/go/pipelines/OnlineCustomers/385/Publish/1" />
  <Project name="OnlineCustomers :: AcceptanceTest" activity="Sleeping" lastBuildStatus="Failed" lastBuildLabel="1.385" lastBuildTime="2011-04-11T18:28:01" webUrl="http://192.168.105.28:8153/go/pipelines/OnlineCustomers/385/AcceptanceTest/1" />
</Projects>
    }
    subject.stub!(:rss).and_return(rss)
    subject.check.should == {
        "Addressing :: fullbuild" => :green,
        "Addressing :: package" => :yellow,
        "Addressing :: Publish" => :green,
        "OnlineCustomers :: UnitTest" => :red,
        "OnlineCustomers :: Publish" => :green,
        "OnlineCustomers :: AcceptanceTest" => :red
    }
  end



end
