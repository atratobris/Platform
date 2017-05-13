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

class NewsArticles < Board

  def get_methods
    {
      next: "change article"
    }
  end

  def next
    if ExternalDatum.source_types.include? metadata['source']
      data = ExternalDatum.find_by(source_type: metadata['source']).data
    else
      data = ExternalDatum.first.data
    end
    index = (self.metadata.dig('id').to_i + 1 < data.length) ? metadata.dig('id').to_i + 1 : 0
    update_board data.dig(index, 'title'), data.dig(index, 'href'), index
    broadcast
    sync_data
  end

  def board_image
    "https://upload.wikimedia.org/wikipedia/commons/8/8d/News.svg"
  end

  def update_board value, href, id
    m = metadata
    m['value'] = value
    m['id'] = id
    m['href'] = href
    update! metadata: m
  end

  def public_metadata
    { source: metadata['source'] }
  end

end
