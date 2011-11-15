#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..")))

require 'rubygems'
require 'lib/runner'
require 'lib/go_monitor'
require 'lib/hudson_monitor'


class LightCollection
  def initialize(lights)
    go_monitor = GoMonitor.new('http://dev:dev@go.server.local:8153/go/cctray.xml')
    hudson_monitor = HudsonMonitor.new('http://ci.server.local:8080/rssLatest')

    @runner = Runner.new

    project1_light = lights[:project1]
    project1_light.projects = ['Project1 :: main', 'Project1 :: war', 'Project1 :: test']
    @runner.add_monitor_light_pair(go_monitor, project1_light)

    project2_light = lights[:project2]
    project2_light.projects = ['Project2 :: fullbuild', 'Project2 :: package']
    @runner.add_monitor_light_pair(go_monitor, project2_light)

    project3_light = lights[:project3]
    project3_light.projects = ['Project3 :: UnitTest', 'Project3 :: AcceptanceTest']
    @runner.add_monitor_light_pair(go_monitor, project3_light)
  end

  def run
    @runner.start
  end
end
