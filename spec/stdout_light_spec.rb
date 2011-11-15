require 'spec_helper'
require 'lib/stdout_light'

describe StdoutLight do
  subject { StdoutLight.new 'test light' }
  
  it 'should show yellow above all other colors' do
    subject.should_receive(:yellow)
    subject.status = {
      'Project 1' => :green,
      'Project 2' => :yellow,
      'Project 3' => :red
    }
  end
  
  it 'should show red above green' do
    subject.should_receive(:red)
    subject.status = {
      'Project 1' => :green,
      'Project 3' => :red
    }
  end
  
  it 'should show green if no red or yellow' do
    subject.should_receive(:green)
    subject.status = {
      'Project 1' => :green,
      'Project 3' => :green
    }
  end
  
  it 'should only track given projects' do
    subject.projects = ['Project 1']
    subject.should_receive(:green)
    subject.status = {
      'Project 1' => :green,
      'Project 3' => :red
    }
  end

  it 'should fail to red if there is no status for a project' do
    subject.projects = ['Project1', 'Project2']
    subject.should_receive(:red)
    subject.status = {
        'Project1' => :green
    }

  end
end