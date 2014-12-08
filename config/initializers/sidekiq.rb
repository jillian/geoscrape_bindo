require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'jmac84242' && password == '12345678'
end

if Rails.env.production?

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDISTOGO_URL"]}
  end
  
  Sidekiq.configure_client do |config|
    config.redis = { url: ENV["REDISTOGO_URL"]}
  end

end