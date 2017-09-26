class CreateTokensService
  def call
    AuthToken.create(user_id: User.first[:id])
  end
end
