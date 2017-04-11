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
#

class Logicboard < Board

  def get_methods
    {
      loop: "activate links"
    }
  end

  def loop
    InputBroadcastJob.perform_now self
  end

  def run
    while true
      broadcast
      sketch = find_sketch
      links = find_boards sketch, key: 'from'
      links.each do |link|
        b = Board.find_by mac: link['to']
        BoardActionJob.perform_later b, link['logic']
      end
      sleep(1)
    end
  end

  def update_board value, href, id
    update! metadata: { value: value, id: id, href: href }
  end

end
