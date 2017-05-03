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

class Input < Board

  def get_methods
    { run: "activate" }
  end

  def broadcast
    Log.sent "Input Board: #{name}<#{mac}> triggered"
    ActionCable.server.broadcast "watcher_channel#{user_id}", message: board_activity
  end

  def run
    broadcast
    sketch = find_sketch
    links = find_links sketch, key: 'from'
    links.each do |link|
      Link.new(link['from'], link['to'], link['logic']).run
    end
    super
  end
end
