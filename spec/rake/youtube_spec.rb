require "rails_helper"
require "spec_helper"
require 'rake'

describe "youtube" do
  before :all do
    Rake.application.rake_require "tasks/youtube"
    Rake::Task.define_task(:environment)
  end


  describe "duration_parser" do
    it "should be good" do

    end
  end
end