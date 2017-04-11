class SketchChannel < ApplicationCable::Channel
  CHANNEL_NAME = "SketchChannel"
  def subscribed
    stream_from "sketch_channel#{params[:mac]}"
    if board = find_board
      Log.connect(board.name, board.mac, CHANNEL_NAME)
      board.update status: "online"
    else
      Log.error "Invalid Board params(#{params.inspect}) #{board.mac}"
    end
  end

  def unsubscribed
    if board = Board.find_by(mac: params[:mac])
      Log.disconnect(board.name, board.mac, CHANNEL_NAME)
      board.update status: "offline"
    end
  end

  def blink data
    if board = Board.find_by(mac: params[:mac])
      board = board.becomes(board.subtype.constantize)
      Log.received "Received input from #{board.name}<#{board.mac}>"
      InputBroadcastJob.new.perform board
      # board.run
    end
  end

  private

  def find_board
    if board = Board.find_by(mac: params[:mac])
      board
    else
      Board.create(mac: params[:mac], type: params[:type])
    end
  end
end
