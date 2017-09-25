class CreateUsersService
  def call
    User.create!(email: "test@example.com", password: "mysecret")
  end
end

