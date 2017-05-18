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
#  image_url       :string
#

class Led < Board
  LED_PIN = 13.to_s

  def get_methods
    {
      toggle: "turn on or off",
      blink: "blink once",
      blink_twice: "blink twice",
      sync_data: "Sync value"
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
    sync_data
  end

  def board_image
    "https://image.flaticon.com/icons/svg/48/48843.svg"
  end

  def blink
    toggle
    sleep(1)
    toggle
    sync_data
  end

  def blink_twice
    blink
    sleep(1)
    blink
    sync_data
  end

  def public_metadata
    {
      LED_PIN => metadata[LED_PIN]
    }
  end

  def sync board
    update_board board.metadata.dig(LED_PIN)
    broadcast
  end

  private

  def current_value
    metadata[LED_PIN].to_i
  end

  def update_board value
    update! metadata: { LED_PIN => value, type: "led" }
  end
end
