# README

> Version Ruby

```
ruby  2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
rails 5.1.4

echo "2.4.1" > .ruby-version
echo "gem: --no-ri --no-rdoc --no-document --suggestions" > .gemrc
```

> Create `.pryrc`

```
if Rails.env.development? || Rails.env.test?
  extend Hirb::Console
end

# === EDITOR ===
Pry.editor = 'vim'

# == Pry-Nav - Using pry as a debugger ==
Pry.commands.alias_command 'c', 'continue' rescue nil
Pry.commands.alias_command 's', 'step' rescue nil
Pry.commands.alias_command 'n', 'next' rescue nil

# === CUSTOM PROMPT ===
Pry.prompt = [proc { |obj, nest_level, _| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " }, proc { |obj, nest_level, _| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }]

# === Listing config ===
Pry.config.ls.separator = "\n"
Pry.config.ls.heading_color = :magenta
Pry.config.ls.public_method_color = :green
Pry.config.ls.protected_method_color = :yellow
Pry.config.ls.private_method_color = :bright_black

# == PLUGINS ===
begin
  require 'rubygems'
  require 'awesome_print'

  AwesomePrint.defaults={:theme=>:solorized}
  Pry.config.print = proc { |output, value| output.puts value.ai }
end

# === CONVENIENCE METHODS ===
class Array
  def self.toy(n=10, &block)
    block_given? ? Array.new(n,&block) : Array.new(n) {|i| i+1}
  end
end

class Hash
  def self.toy(n=10)
    Hash[Array.toy(n).zip(Array.toy(n){|c| (96+(c+1)).chr})]
  end
end
```

We will also use Rails URL helpers for link generation and have to
specify default URL options in environment files. Here is what I added
in `development.rb` and `test.rb` files in `config/environments/ directory`:

```
Rails.application.routes.default_url_options = {
  host: 'localhost',
  port: 3000
}
```

> Create new project

```
rails new rails-chats-api --api --skip-yarn --skip-git --skip-keeps --skip-action-mailer --skip-action-cable --skip-test --skip-system-test
```

> Add packages

```
gem 'bcrypt', '~> 3.1'
gem 'active_model_serializers'

group :development, :test do
  gem 'rspec-rails'
  gem 'awesome_print'
  gem 'awesome_rails_console'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
end

group :test do
  gem 'shoulda-matchers'
  gem 'rspec-its'
  gem 'rspec-activemodel-mocks'
  gem 'shoulda-callback-matchers'
end
```

> Setup RSpec

```
rails generate rspec:install
```

edit file `.rspec`:

```
--color
--format d
--require spec_helper
```

edit file `spec/rails_helper.rb`:

```
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = :random

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```

edit file `spec/spec_helper.rb`:

```
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
```

Edit `config/application.rb`:

```
module RailsChatsApi
  class Application < Rails::Application
    config.load_defaults 5.1
    config.api_only = true

    config.generators do |g|
      g.orm :active_record, migration: true
      g.test_framework :rspec, fixtures: false
      g.helper false
      g.decorator false
      g.controller assets: false
    end
  end
end
```

Check it out `bundle exec rspec`

> Create controllers

```
rails g controller Sessions
rails g controller Profiles
```

Edit routes `config/routes.rb`:

```
Rails.application.routes.draw do
  resource :session, only: [:create, :destroy]
  resource :profile, only: [:create, :show]
end
```

Check it out routes: `rake routes`

```
 Prefix Verb   URI Pattern        Controller#Action
session DELETE /session(.:format) sessions#destroy
        POST   /session(.:format) sessions#create
profile GET    /profile(.:format) profiles#show
        POST   /profile(.:format) profiles#create
```

> Create models

```
rails g model user email password_digest
rails g model chat message
rails g model auth_token value user:belongs_to

#rails g model chats_user value:string  chats_userable:references{polymorphic}
#rails g model chats_user value auth_tokenable_id:integer auth_takenable_type
```

Edit model `app/models/user.rb`:

```
class User < ApplicationRecord
  before_save :downcase_fields

  has_one :auth_token, dependent: :destroy

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
    length: { minimum: 5, maximum: 35 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  def self.valid_login?(email, password)
    user = find_by(email: email)
    if user && user.authenticate(password)
      user
    end
  end

  private

  def downcase_fields
    self.email = email.downcase
  end
end
```

Edit model `app/models/auth_token.rb`:

```
class AuthToken < ApplicationRecord
  before_create :generate_token

  belongs_to :user

  private

  def generate_token
    begin
      self.value = SecureRandom.hex
    end while self.class.exists?(value: value)
  end
end
```

Edit model `app/models/chat.rb`:

```
class Chat < ApplicationRecord
  before_save :downcase_fields

  validates :message, presence: true,
    length: { minimum: 4,  maximum: 25, allow_blank: false }

  private

  def downcase_fields
    self.message = message.downcase
  end
end
```

> Create services `app/services/*`:

```
mkdir app/services
touch app/services/create_users_service.rb
touch app/services/create_chats_service.rb
touch app/services/create_tokens_service.rb
```

Edit file `app/services/create_users_service.rb`:

```
class CreateUsersService
  def call
    User.create!(email: "test@example.com", password: "mysecret")
  end
end
```

Edit file `app/services/create_chats_service.rb`:

```
class CreateChatsService
  def call
    Chat.create(message: "My First Message!")
  end
end
```

Edit file `app/services/create_tokens_service.rb`:

```
class CreateTokensService
  def call
    AuthToken.create(user_id: User.first[:id])
  end
end
```

Edit file `db/seeds.rb`:

```
if Rails.env.development?
  puts "━━━━━━━━━━━ Creating Users ━━━━━━━━━━━"
  CreateUsersService.new.call
  puts 'Users Total: ' << "#{User.count}"
  puts "━━━━━━━━━━━ Creating Users ━━━━━━━━━━━"
  CreateTokensService.new.call
  puts 'Token Total: ' << "#{AuthToken.count}"
  puts "━━━━━━━━━━━ Creating Chats ━━━━━━━━━━━"
  CreateChatsService.new.call
  puts 'Chats Total: ' << "#{Chat.count}"
  puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
end

if Rails.env.test?; end
if Rails.env.production?; end
```

Clean up rspec files `spec/*`:

```
# spec/controllers/profiles_controller_spec.rb
require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do

end
```

```
# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

end
```

```
# spec/models/auth_token_spec.rb
require 'rails_helper'

RSpec.describe AuthToken, type: :model do

end
```

```
# spec/models/chat_spec.rb
require 'rails_helper'

RSpec.describe Chat, type: :model do

end
```

```
# spec/models/chats_user_spec.rb
require 'rails_helper'

RSpec.describe ChatsUser, type: :model do

end
```

```
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do

end
```

Run clean logs: `rake tmp:clear log:clear`

Run migrations: `rake db:create db:migrate db:seed`

Run rspec: `bundle exec rspec`

> Setup serializers

```
# app/serializers/user_serializer.rb

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email
end
```

> Setup controllers

```
# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def authenticate!
    authenticate_token || render_unauthorized("Access denied")
  end

  def current_user
    @current_user ||= authenticate_token
  end

  protected

  def render_unauthorized(message)
    errors = { errors: [ { detail: message } ] }.to_json
    render json: errors, status: :unauthorized
  end

  private

  def authenticate_token
    authenticate_or_request_with_http_token do |token, options|
      User.joins(:auth_token).find_by(auth_tokens: { value: token })
    end
  end
end
```

```
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate!, only: [:create], raise: false

  def create
    if @current_user = User.valid_login?(params[:email], params[:password])
      render json: { api_token: @current_user.auth_token.value }.to_json
    else
      render_unauthorized("Error with your login or password")
    end
  end

  def destroy
    @current_user.logout
    head :ok
  end
end
```

### 26 Sep 2017 Oleg G.Kapranov
