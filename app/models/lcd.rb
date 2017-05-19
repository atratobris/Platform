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

class Lcd < Board

  def get_methods
    {
      sync_data: "Get article headline"
    }
  end

  def run
    broadcast
  end

  def sync board
    update_board board.metadata.dig("value")
  end

  def hello
    update_board "hello world"
  end

  def board_image
    "https://www.jamesrobertson.eu/svg/2012/oct/13/1602lcd.svg"
  end

  def buna
    update_board "buna dimineata"
  end

  def update_board value
    update! metadata: { type: 'lcd_display', value: value }
    broadcast
  end

  def public_metadata
    { 'value' => metadata['value'] }
  end

end
