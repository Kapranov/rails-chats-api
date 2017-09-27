if Rails.env.development?
  puts "━━━━━━━━━━━ Creating Users ━━━━━━━━━━━"
  CreateUsersService.new.call
  puts 'Users Total: ' << "#{User.count}"
  puts "━━━━━━━━━━━ Creating Token ━━━━━━━━━━━"
  CreateTokensService.new.call
  puts 'Token Total: ' << "#{AuthToken.count}"
  puts "━━━━━━━━━━━ Creating Chats ━━━━━━━━━━━"
  CreateChatsService.new.call
  puts 'Chats Total: ' << "#{Chat.count}"
  puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
end

if Rails.env.test?; end
if Rails.env.production?; end
