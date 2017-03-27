RSpec.describe Sketch::CodeGenerator do
  let!(:sketch) { create(:sketch, boards: boards, links: links) }
  let!(:input) { create(:board, name: "Motion Sensor") }
  let!(:led) { create(:led) }

  describe "generator" do
    subject { Sketch::CodeGenerator.new(sketch) }

    it "generates for a simple sketch" do
      code = subject.generate

      expect(code).to include "def toggle"
      expect(code).to include "if motion_sensor.received"
    end
  end

  private

  def boards params = {}
    [
      {
        mac: input.mac
      },
      {
        mac: led.mac
      }
    ]
  end

  def links params = {}
    [
      {
        from: input.mac,
        to: led.mac,
        logic: 'toggle'
      }
    ]
  end
end
