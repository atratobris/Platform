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
#

FactoryGirl.define do
  factory :board do
    type "Input"
    mac "1234"
    register_status "registered"
  end

  factory :led do
    type "Led"
    mac "1234"
    register_status "registered"
  end
end
