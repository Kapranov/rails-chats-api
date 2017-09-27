class AuthTokenSerializer < ActiveModel::Serializer
  attributes :user_id, :value
  belongs_to :user
end
