class AddAuxTypeColumnToBoards < ActiveRecord::Migration[5.1]
  def change
    add_column :boards, :subtype, :string
    Board.find_each do |b|
      case b.type
      when "Andboard", "Pseudoboard"
        b.update(subtype: "VirtualBoard")
      else
        b.update(subtype: "RealBoard")
      end
    end
  end
end
