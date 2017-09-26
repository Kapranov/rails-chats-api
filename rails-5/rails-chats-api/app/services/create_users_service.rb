class CreateUsersService
  def call
    User.create!(email: "Test@Example.Com", password: "mysecret")
  end
end

