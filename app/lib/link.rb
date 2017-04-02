class Link

  def initialize from_mac, to_mac, logic
    @from_board = Board.find_by mac: from_mac
    @to_board = Board.find_by mac: to_mac
    @logic = logic
  end

  def run
    BoardActionJob.perform_now @to_board, @logic
  end
end
