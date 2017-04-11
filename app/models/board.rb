# == Schema Information
#
# Table name: boards
#
#  id              :integer          not null, primary key
#  mac             :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :integer          default("offline")
#  metadata        :jsonb
#  name            :string           default("")
#  last_active     :datetime
#  type            :string
#  accepted_links  :jsonb
#  register_status :integer          default("unregistered")
#  user_id         :integer
#  ip              :string
#  subtype         :string
#

class Board < ApplicationRecord
  # BOARD_TYPES = %w[ Input Lcd Led Pseudoboard Screen ]
  SketchNotFound = Class.new(RuntimeError)
  include BoardHelper

  # validates :type, inclusion: { in: BOARD_TYPES, message: "must be one of #{BOARD_TYPES}" }, presence: true

  belongs_to :user, optional: true
  after_commit :add_link_types, on: [:update, :create]


  enum status: {
    offline: 0,
    online: 1

  }

  enum register_status: {
    unregistered: 0,
    pending: 1,
    registered: 2
  }

  scope :for_user, -> (user_id) { where(user_id: user_id) }
  scope :for_type, -> (type) { where(type: type) }

  def run
    sync_data
  end

  def self.get_methods
    {}
  end

  def show_delete_path
    Rails.application.routes.url_helpers.admin_board_path(id)
  end

  def edit_path
    Rails.application.routes.url_helpers.edit_admin_board_path(id)
  end

  def user_details
    "#{user&.name}<#{user&.email}>"
  end


  def add_in_board mac
    m = metadata
    m["in_boards"].push mac
    update! metadata: m
  end

  def add_out_board mac
    m = metadata
    m["out_boards"].push mac
    update! metadata: m
  end

  def clear_boards_metadata
    m = metadata
    m['in_boards'] =  []
    m['out_boards'] = []
    update! metadata: m
  end

  protected

  def board_activity
    { mac: mac }
  end

  def broadcast
    Log.sent "Board: #{name}<#{mac}> broadcasting (#{metadata}) to channel"
    ActionCable.server.broadcast "watcher_channel#{user_id}", message: board_activity
    ActionCable.server.broadcast "sketch_channel#{mac}", message: metadata
  end

  def find_sketch
    logger.debug "Finding sketch for #{mac}"
    # There should be no problem interpolating here because the mac is a db value
    Sketch
      .where(status: :active)
      .where("boards @> '[{\"mac\":\"#{mac}\"}]'")
      .first or alert_error
  end

  def find_boards sketch, key: "from"
    sketch.links.select{ |l| l[key] == mac }
  end

  def add_link_types
    return if accepted_links.with_indifferent_access == subtype.constantize.get_methods.with_indifferent_access()
    update! accepted_links: subtype.constantize.get_methods
  end

  def update_last_active
    return unless status == "online" || status_was == "online"
    self.last_active = Time.now
  end

  def sync board
  end

  def required_info
    {}
  end


  # sync the boards which have an ingoing sync_data link from this board
  def sync_data
    sketch = find_sketch
    links = sketch.links.select{ |l| l["logic"] == "sync_data"}
    links.each do |link|
      if link["from"] == mac
        # gets data from this board into the other one
        b = Board.find_by(mac: link["to"])
        b.becomes(b.subtype.constantize).sync self
      end
    end
  end


  def alert_error
    Log.create! log_type: "error", message: "Couldn't find active sketch for #{name}<#{mac}>"
    raise SketchNotFound
  end
end
