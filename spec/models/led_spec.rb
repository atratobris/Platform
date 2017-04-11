# == Schema Information
#
# Table name: boards
#
#  id              :integer          not null, primary key
#  mac             :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :integer          default("offline")
#  metadata        :jsonb
#  name            :string           default("")
#  last_active     :datetime
#  type            :string
#  accepted_links  :jsonb
#  register_status :integer          default("unregistered")
#  user_id         :integer
#  ip              :string
#  subtype         :string
#

require 'rails_helper'

RSpec.describe Led, type: :model do
  before do
    allow_any_instance_of(Led).to receive(:broadcast).and_return true
  end

  it "is valid" do
    expect(build(:board)).to be_valid
  end

  it "has a valid factory" do
    expect(create(:led)).to be_valid
  end

  describe ".current_value" do
    it "returns pin value" do
      (0..1).each do |value|
        led = create(:led, mac: "1", metadata: { Led::LED_PIN => value})
        expect( led.send(:current_value) ).to eq value
      end
    end
  end

  describe ".update_board" do
    it "sets the correct value" do
      led1 = create(:led, mac: "1")
      led2 = create(:led, mac: "2")

      led1.send(:update_board, 1)
      led2.send(:update_board, 0)

      expect(led1.send(:current_value)).to eq 1
      expect(led2.send(:current_value)).to eq 0
    end
  end

  describe ".toggle" do
    it "flips the led value" do
      led = create(:led, mac: "1")
      (0..1).each do |value|
        led.send(:update_board, value)
        led.send(:toggle)
        expect(led.send(:current_value)).to eq (value+1)%2
      end
    end
  end

  describe "blink" do
    let(:led) { create(:led) }

    before do
      allow_any_instance_of(Led).to receive(:toggle).and_return true
      allow_any_instance_of(Led).to receive(:sleep).and_return true
    end

    it "calls toggle twice" do
      led.blink

      expect(led).to have_received(:toggle).exactly(2).times
    end

    it "calls sleep once" do
      led.blink

      expect(led).to have_received(:sleep).exactly(1).times.with(1)
    end
  end

end
