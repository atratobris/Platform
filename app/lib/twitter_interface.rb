class TwitterInterface
  INTERVAL = 30.seconds

  attr_reader :client

  def initialize
    @client = config_client
  end

  def catalins_tweets
    client.user_timeline("cionescu1")
  end

  def find_sketches
    Sketch.active.each do |sketch|
      next unless board = sketch.find_twitter_board
      check_twitter_activity board
    end
  end

  private

  def config_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.consumer_key
      config.consumer_secret     = Rails.application.secrets.consumer_secret
      config.access_token        = Rails.application.secrets.access_token
      config.access_token_secret = Rails.application.secrets.access_secret
    end
  end

  def check_twitter_activity board
    last_tweet = extract_info get_last_tweet board
    if board.last_tweet.present? && board.last_tweet.dig("url") != last_tweet["url"]

    elsif Time.current - last_tweet["created_at"] < INTERVAL

    else #Ignore Tweet
      Rails.logger.debug "TwitterInterface: Ignoring Tweet #{last_tweet[:handle]} for board #{board.mac}"
    end
  end

  def get_last_tweet board
    if board.source.start_with?("@")
      client.user_timeline(board.source.remove!("@")).first
    elsif board.source.start_with?("#")
      client.search(board.source).first
    end
  end

  def extract_info tweet
    url = tweet.url
    {
      url: "#{url.scheme}://#{url.host}#{url.path}",
      user: tweet.user.name,
      handle: tweet.user.screen_name,
      text: tweet.text,
      created_at: tweet.created_at
    }.stringify_keys
  end
end
