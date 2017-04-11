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

class Andboard < VirtualBoard

  def self.get_methods
    { add: "+ one" }
  end

  def add mac
    if metadata["in_boards"].include?(mac)
      if metadata["#{mac}"].zero?
        set_mac_signal mac, 1
      else
        set_mac_signal mac, 0
      end
      activate_boards if condition_true
    end
  end

  def required_info
    { add: "mac" }
  end

  def condition_true
    metadata['in_boards'].each do |b|
      return false if metadata[b].zero?
    end
    return true
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

  def set_mac_signal mac, signal
    m = metadata
    m["#{mac}"] = signal
    update! metadata: m
  end

  def update_board value
    # m = metadata
    # metadata
    update! metadata: { "total" => value%2 }
  end

end
