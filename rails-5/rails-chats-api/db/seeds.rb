if Rails.env.development?
  puts "━━━━━━━━━━━ Creating Users ━━━━━━━━━━━"
  CreateUsersService.new.call
  puts 'Users Total: ' << "#{User.count}"
  puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
end

if Rails.env.test?; end
if Rails.env.production?; end
