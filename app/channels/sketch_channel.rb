class SketchChannel < ApplicationCable::Channel
  CHANNEL_NAME = "SketchChannel"
  def subscribed
    stream_from "sketch_channel#{params[:mac]}"
    if board = find_board
      Log.connect(board.name, board.mac, CHANNEL_NAME)
      board.update status: "online"
      board.report_status
    else
      Log.error "Invalid Board params(#{params.inspect}) #{board.mac}"
    end
  end

  def unsubscribed
    if board = Board.find_by(mac: params[:mac])
      Log.disconnect(board.name, board.mac, CHANNEL_NAME)
      board.update status: "offline"
      board.report_status
    end
  end

  def blink data
    if board = Board.find_by(mac: params[:mac])
      Log.received "Received input from #{board.name}<#{board.mac}>"
      InputBroadcastJob.perform_now board
    end
  end

  private

  def find_board
    if board = Board.find_by(mac: params[:mac])
      board
    else
      Board.create(mac: params[:mac], type: params[:type], register_status: "registered", user_id: params[:user_id])
    end
  end
end
