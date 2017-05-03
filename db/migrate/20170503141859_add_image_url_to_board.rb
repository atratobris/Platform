class AddImageUrlToBoard < ActiveRecord::Migration[5.1]
  def change
    add_column :boards, :image_url, :string
  end
end
