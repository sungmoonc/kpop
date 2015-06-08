require "rails_helper"
require "spec_helper"
require 'rake'

describe "youtube" do
  before :all do
    Rake.application.rake_require "tasks/youtube"
    Rake::Task.define_task(:environment)
  end


  describe "duration_to_seconds" do
    it "should correctly parse duration" do
      expect(duration_to_seconds("PT45S")).to be 45
      expect(duration_to_seconds("PT1H")).to be 3600
      expect(duration_to_seconds("PT23M")).to be 1380
      expect(duration_to_seconds("PT1H23M")).to be 4980
      expect(duration_to_seconds("PT1H45S")).to be 3645
      expect(duration_to_seconds("PT23M45S")).to be 1425
      expect(duration_to_seconds("PT1H23M45S")).to be 5025
    end

    it "should fail parsing duration" do
      expect(duration_to_seconds("PT45S")).not_to be 60
    end
  end

  describe "category_parsing" do
    it "should categorize music video" do
      expect(category_parsing("music video")).to be :musicvideo
      expect(category_parsing("Music video")).to be :musicvideo
    end

    it "should categorize teaser" do
      expect(category_parsing("티저 영상")).to be :teaser
    end

    it "should categorize dancepractice" do
      expect(category_parsing("ZE:A[제국의아이들] 비틀비틀(St-Dagger) 안무영상")).to be :dancepractice
    end

    it "should categorize making" do
      expect(category_parsing("뮤직비디오 메이킹 필름")).to be :making
    end

    it "should categorize other" do
      expect(category_parsing("알 수 없는 제목")).to be :other
    end

  end

end