# == Schema Information
#
# Table name: external_data
#
#  id          :integer          not null, primary key
#  source_type :integer
#  data        :jsonb
#  name        :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null


class ExternalDatum < ApplicationRecord
  enum source_type: {
    cnn: 0,
    reuters: 1
  }
end
