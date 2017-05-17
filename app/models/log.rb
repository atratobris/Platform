# == Schema Information
#
# Table name: logs
#
#  id         :integer          not null, primary key
#  log_type   :integer
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Log < ApplicationRecord
  CHANNEL = 'log_channel'
  LOG_LIMIT = 50

  enum log_type: {
    error: 0,
    connected: 1,
    disconnected: 2,
    input_received: 3,
    output_sent: 4,
    register: 5
  }

  after_commit :send_channel_update, on: :create

  scope :latest_logs, -> {
    ids = where(created_at: (Time.now.beginning_of_day..Time.now.end_of_day)).order("id desc").limit(LOG_LIMIT).pluck(:id)
    where(id: ids).order("id asc")
  }

  def self.send_latest
    ActionCable.server.broadcast 'log_channel', message: serialize_logs
  end

  def self.connect board_name, board_mac, channel
    create! log_type: "connected", message: "Board: #{board_name}<#{board_mac.truncate(20)}> connected to the #{channel}."
  end

  def self.disconnect board_name, board_mac, channel
    create! log_type: "disconnected", message: "Board: #{board_name}<#{board_mac.truncate(20)}> disconnected from the #{channel}."
  end

  def self.error message
    create! log_type: "error", message: message
  end

  def self.received message
    create! log_type: "input_received", message: message
  end

  def self.sent message
    create! log_type: "output_sent", message: message
  end

  def self.register board, old_status
    create! log_type: "register", message: "Board: #{board.name}<#{board.mac.truncate(20)}> changed from #{old_status} to #{board.register_status}"
  end

  private

  def self.serialize_logs
    latest_logs.map do |log|
      LogSerializer.new(log).as_json
    end
  end

  def send_channel_update
    ActionCable.server.broadcast 'log_channel', message: [LogSerializer.new(Log.last).as_json]
  end
end
