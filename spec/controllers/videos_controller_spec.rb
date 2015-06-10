require "rails_helper"
require "spec_helper"

describe VideosController do
  describe "get_range_filters" do
    it "should return conditions correctly" do
      controller = VideosController.new

      mock_params = {
        'hello' => {
          min: 0,
          max: 10
        },
        'world' => {
          min: 5,
          max: 8
        }
      }

      expect(
        controller.send(:get_range_filters, mock_params, "hello", "world")
      ).to eq ["hello >= 0 and hello <= 10", "world >= 5 and world <= 8"]
    end
  end


end