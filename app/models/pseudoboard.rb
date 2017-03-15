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

class Pseudoboard < Board

  def get_methods
    {
      next: "change article"
    }
  end

  def next
    data = ExternalDatum.first.data
    index = (self.metadata.dig('id').to_i + 1 < data.length) ? metadata.dig('id').to_i + 1 : 0
    update_board data.dig(index, 'title'), data.dig(index, 'href'), index
    broadcast
    sync_data
  end

  def update_board value, href, id
    update! metadata: { value: value, id: id, href: href }
  end

end
