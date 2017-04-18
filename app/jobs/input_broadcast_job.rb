class InputBroadcastJob < ApplicationJob
  queue_as :default

  def perform board
    board.run
  end
end
