Rails.application.configure do
  config.cache_classes = true
  config.eager_load = false

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.seconds.to_i}"
  }

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.active_support.deprecation = :stderr
  # config.action_view.raise_on_missing_translations = true
end

Rails.application.routes.default_url_options = {
  host: 'localhost',
  port: 3000
}
