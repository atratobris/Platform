# == Schema Information
#
# Table name: boards
#
#  id         :integer          not null, primary key
#  mac        :string
#  button     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Board < ApplicationRecord
end
