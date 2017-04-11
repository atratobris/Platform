class Link

  def initialize from_mac, to_mac, logic
    # find origin board
    @from_board = Board.find_by mac: from_mac

    # find destination board and cast it to its subtype class
    @to_board = Board.find_by mac: to_mac
    @to_board = @to_board.becomes(@to_board.subtype.constantize)
    @logic = logic
  end

  def run
    if @logic == "add"
      @to_board.public_send(@logic, @from_board.mac)
    else
      BoardActionJob.perform_now @to_board, @logic
    end
end
end
