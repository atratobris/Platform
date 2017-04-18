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

class Led < Board
  LED_PIN = 13.to_s

  def get_methods
    {
      toggle: "turn on or off",
      blink: "blink once",
      blink_twice: "blink twice"
    }
  end

  def run
    toggle
    broadcast
  end

  def toggle
    if current_value.zero?
      update_board 1
    else
      update_board 0
    end
    broadcast
  end

  def blink
    toggle
    sleep(1)
    toggle
  end

  def blink_twice
    blink
    sleep(1)
    blink
  end

  private

  def current_value
    metadata[LED_PIN].to_i
  end

  def update_board value
    update! metadata: { LED_PIN => value, type: "led" }
  end
end
