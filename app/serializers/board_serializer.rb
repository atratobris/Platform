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
#

class BoardSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id, :mac, :status, :name, :last_activity, :type, :accepted_links

  def last_activity
    "#{distance_of_time_in_words(Time.now, object.last_active, include_seconds: true)} ago"
  end
end
