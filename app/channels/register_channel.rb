class RegisterChannel < ApplicationCable::Channel
  def subscribed
    stream_from "register_channel"
    if board = Board.find_or_create_by(mac: params[:mac])
      Log.record_connection(board.name, board.mac)
      board.update status: "online"
      ActionCable.server.broadcast 'register_channel', board: board, type: 'board_details'
    end
  end

  def unsubscribed

  end

  def register data
    if board = Board.find_by(mac: params[:mac])
      board.update register_status: 'registered'
      ActionCable.server.broadcast 'register_channel', board: board, type: 'board_details'
    end
  end
end