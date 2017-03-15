class WatcherChannel < ApplicationCable::Channel
  CHANNEL_NAME = "WatcherChannel"
  def subscribed
    if user = User.find params.require(:user_id)
      stream_from "watcher_channel#{user.id}"
    end
  end

  def unsubscribed
  end

end
