class InputBroadcastJob < ApplicationJob
  queue_as :default

  def perform board
    board.becomes(board.subtype.constantize)
    board.run
  end
end
