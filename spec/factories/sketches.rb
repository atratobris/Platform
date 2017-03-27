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

FactoryGirl.define do
  factory :sketch do
    status "active"
  end
end
