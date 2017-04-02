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

class Andboard < Board

  def get_methods
    { add: "+ one" }
  end

  def add
    update_board current_value+1
    broadcast
    if current_value == 0
      activate_boards
    end
  end

  def activate_boards
    sketch = find_sketch
    links = find_boards sketch, key: 'from'
    links.each do |link|
      b = Board.find_by mac: link['to']
      BoardActionJob.perform_now b, link['logic']
    end
  end

  def current_value
    metadata["total"].to_i
  end

  def update_board value
    update! metadata: { "total" => value%2 }
  end

end
