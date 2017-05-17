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

class TwitterBoard < Board
  def get_methods
    {
      run: "Act as Input",
      sync_and_run: "Sync the Twitter feed and Open Article"
    }
  end

  def board_image
    "https://upload.wikimedia.org/wikipedia/en/9/9f/Twitter_bird_logo_2012.svg"
  end

  def run
    Log.sent "Twitter Input Board with source: #{source} triggered"
    broadcast
  end

  def sync_and_run
    sketch = find_sketch

    sketch.links.each do |link|
      if link["from"] == mac
        target_board = Board.find_by(mac: link["to"])
        target_board.metadata['url'] = last_tweet.dig("url")
        target_board.save!
        target_board.broadcast
      end
    end
  end

  def public_metadata
    { source: source }
  end

  def last_tweet
    metadata["last_tweet"]&.with_indifferent_access
  end

  def source
    metadata["source"]
  end

  def execute
    # Ideally here, we should pull the sketch and run the actual link selected there
    sync_and_run
  end
end
