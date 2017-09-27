class UserSerializer < ActiveModel::Serializer
  attributes :email, :auth_token
  has_one :auth_token, include: :all
end
