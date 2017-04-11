class BoardActionJob < ApplicationJob
  queue_as :default

  def perform board, action
    logger.debug "Running #{action} for #{board.name} #{board.mac}"
    if board.get_methods.has_key?(action.to_sym)
      board.public_send(action)
    else
      logger.debug "Board #{board.mac} doesn't support logic #{action}"
      Log.error "Board #{board.name}<#{board.mac}> doesn't support logic #{action}"
    end
  end
end
