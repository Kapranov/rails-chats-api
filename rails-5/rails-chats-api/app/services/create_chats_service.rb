class CreateChatsService
  def call
    Chat.create(message: "My First Message!")
  end
end

