# == Schema Information
#
# Table name: sketches
#
#  id           :integer          not null, primary key
#  links        :jsonb            not null
#  boards       :jsonb            not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  published_at :datetime
#  trashed_at   :datetime
#  status       :integer          default("closed")
#  name         :string           default("")
#  user_id      :integer
#  creator_id   :integer
#  listed       :boolean          default(FALSE)
#  description  :string           default("")
#

class Sketch < ApplicationRecord

  belongs_to :user, optional: true
  belongs_to :creator, class_name: 'User', optional: true
  before_save :update_boards_metadata, on: :update

  # before_save :disable_other_active_sketches, on: :update
  before_save :update_boards_metadata, on: :update

  enum status: {
    closed: 0,
    active: 1
  }

  scope :for_marketplace, -> { where(listed: true).order(id: :asc) }
  scope :for_user, -> (user_id) { where(user_id: user_id) }

  def show_delete_path
    Rails.application.routes.url_helpers.admin_sketch_path(id)
  end

  def edit_path
    Rails.application.routes.url_helpers.edit_admin_sketch_path(id)
  end

  def user_details
    "#{user&.name}<#{user&.email}>"
  end

  def update_boards_metadata
    boards.each do |board|
      if board["boardConfig"]["type"] == "VirtualBoard"
        board = board["boardConfig"]
        board = board.slice("mac", "name", "type", "subtype")
        board["user_id"] = user_id
        Board.find_or_create_by(board)
      end
      Board.find_by(mac: board['mac']).clear_boards_metadata
    end
    links.each do |link|
      Board.find_by(mac: link['to']).add_in_board link['from']
      Board.find_by(mac: link['from']).add_out_board link['to']
    end
  end

  private

  def disable_other_active_sketches
    return unless status_changed? && status == "active"
    self.class.where.not(id: id).where(status: "active").update_all(status: "closed")
  end
end
