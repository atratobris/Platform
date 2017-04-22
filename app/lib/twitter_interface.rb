class TwitterInterface
  attr_reader :client

  def initialize
    @client = config_client
  end

  def catalins_tweets
    client.user_timeline("cionescu1").map(&:text)
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
end
