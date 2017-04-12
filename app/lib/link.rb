class Link
  attr_reader :logic
  
  def initialize from_mac, to_mac, logic
    @from_board = Board.find_by mac: from_mac
    @to_board = Board.find_by mac: to_mac
    @logic = logic
  end

  def run
    if logic == "add" and @to_board.get_methods.has_key?(logic.to_sym)
      @to_board.public_send(logic, @from_board.mac)
    else
      BoardActionJob.perform_now @to_board, logic
    end
  end
end
