class Purchaser
  attr_accessor :sketch_id, :user, :new_sketch

  def initialize sketch_id, user_id
    @sketch_id = sketch_id
    @user = User.find user_id
    @new_sketch = Sketch.new new_sketch_attributes.merge(default_params)
  end

  def purchase
    update_boards_for_new_user
    new_sketch.save!
    new_sketch
  end

  private

  def new_sketch_attributes
    Sketch
      .for_marketplace
      .find(sketch_id)
      .attributes
      .with_indifferent_access
      .slice(:boards, :links, :name, :description)
  end

  def default_params
    {
      status: "closed",
      user: user
    }
  end

  def update_boards_for_new_user
    new_sketch.boards.each do |sketch_board|
      old_mac = sketch_board["mac"]
      new_board = fine_new_suitable_board old_mac
      sketch_board["mac"] = new_board.mac
      update_links old_mac, new_board.mac
      sketch_board["boardConfig"] = {}
    end
  end

  def update_links old_mac, new_mac
    new_sketch.links.each do |sketch_link|
      sketch_link["to"] = new_mac if sketch_link["to"] == old_mac
      sketch_link["from"] = new_mac if sketch_link["from"] == old_mac
    end
  end

  def old_sketch_boards
    @old_boards ||= Board.where(mac: Sketch.find(sketch_id).boards.map{ |b| b["mac"] }).to_a
  end

  def fine_new_suitable_board old_board_mac
    old_board_type = old_sketch_boards.detect{ |b| b.mac == old_board_mac }.type
    old_board_subtype = old_sketch_boards.detect{ |b| b.mac == old_board_mac }.type
    Rails.logger.info "Old type: #{old_board_type}"

    if old_board_subtype == "RealBoard"
      candidate_boards = Board.for_user(user.id).for_type(old_board_type)
        .reject { |b| new_sketch.boards.map{|board| board["mac"]}.include?(b.mac) }
    else
      candidate_boards = Board.for_user(user.id).for_type(old_board_type)
        .reject { |b| new_sketch.boards.select{|board| board["user_id"] == user.id}.map{|board| board["mac"]}.include?(b.mac) }
      if candidate_boards.empty?
        type_count = Board.for_user(user.id).for_type(old_board_type).count
        mac = "#{old_board_type}#{type_count}"
        candidate_boards.push( Board.create(type: old_board_type, name: old_board_type, subtype: old_board_subtype, mac: mac, user_id: user.id) )
      end
    end

    new_board = candidate_boards.first
    Rails.logger.info "Found suitable board: #{new_board.name}<#{new_board.mac}> | type: #{new_board.type}"
    new_board
  end

end
