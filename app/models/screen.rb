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

class Screen < Board

  def get_methods
    {
      run: "default method",
      sync_data: "synchronize url"
    }
  end

  def sync_data_in
    sketch = find_sketch
    links = sketch.links.select{ |l| l["logic"] == "sync_data"}
    links.each do |link|
      if link["to"] == mac
        sync Board.find_by(mac: link["from"])
      end
    end
  end


  def run
    sync_data_in
    broadcast
  end

  def sync board
    update! metadata: { type: "link_opener", url: board.metadata.dig('href') }
  end
end
