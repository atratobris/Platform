class InputBroadcastJob < ApplicationJob
  queue_as :default

  def perform data, board
    board.becomes(board.subtype.constantize)
    board.run
  end
end
