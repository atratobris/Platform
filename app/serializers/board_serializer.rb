# == Schema Information
#
# Table name: boards
#
#  id             :integer          not null, primary key
#  mac            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  status         :integer          default("offline")
#  metadata       :jsonb
#  name           :string           default("")
#  last_active    :datetime
#  maintype       :string
#  type           :string
#  accepted_links :jsonb
#

class BoardSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id, :mac, :status, :name, :last_activity, :maintype, :type, :accepted_links

  def last_activity
    "#{distance_of_time_in_words(Time.now, object.last_active, include_seconds: true)} ago"
  end
end
