class TwitterBoard < Board
  def get_methods
    { run: "Activate" }
  end

  def board_image
    "https://upload.wikimedia.org/wikipedia/en/9/9f/Twitter_bird_logo_2012.svg"
  end

  def run
    Log.sent "Twitter Input Board with source: #{source} triggered"
  end

  def public_metadata
    { source: source }
  end

  def last_tweet
    metadata["last_tweet"]
  end

  def source
    metadata["source"]
  end
end
