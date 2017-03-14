class WatcherChannel < ApplicationCable::Channel
  CHANNEL_NAME = "WatcherChannel"
  def subscribed
    stream_from "watcher_channel#{params[:user_id]}"
  end

  def unsubscribed
  end

  def blink data
  end
end
