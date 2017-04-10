class VirtualBoardSerializer < ActiveModel::Serializer
  attributes :id, :mac, :status, :name, :last_activity, :type, :accepted_links, :metadata, :subtype
end
