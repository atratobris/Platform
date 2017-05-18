class RegisterChannel < ApplicationCable::Channel
  def subscribed
    stream_from "register_channel#{params[:mac]}"
    if board = Board.find_or_create_by(mac: params[:mac], type: params[:type])
      Log.connect(board.name, board.mac, "RegisterChannel")
      board.update status: "online"
      ActionCable.server.broadcast "register_channel#{params[:mac]}", board: board, type: 'board_details'
    end
  end

  def unsubscribed
  end

  def register data
    if board = Board.find_by(mac: params[:mac])
      old_status = board[:register_status]
      board.update register_status: 'registered'
      Log.register(board, old_status)
      ActionCable.server.broadcast "register_channel#{params[:mac]}", board: board, type: 'board_details'
    end
  end
end
