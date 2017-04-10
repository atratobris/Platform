class AddAuxTypeColumnToBoards < ActiveRecord::Migration[5.1]
  def change
    add_column :boards, :subtype, :string
    Board.find_each do |b|
      b.update(subtype: b.type)
      case b.type
      when "Andboard", "Pseudoboard"
        b.update(type: "VirtualBoard")
      else
        b.update(type: "RealBoard")
      end
    end
  end
end
