class LinkOpener < CodeRunner
  def run parent_board
    board.update! metadata: { type: "link_opener", url: parent_board.metadata.dig('url') }
    super
  end
end
