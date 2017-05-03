class AddImageUrlToBoard < ActiveRecord::Migration[5.1]
  def change
    add_column :boards, :image_url, :string
    Board.find_each do |b|
      b.set_image_url
    end
  end
end
