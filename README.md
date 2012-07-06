Omniauth strategy for TripIt.

To use, add the gem to your `Gemfile`:

    gem 'omniauth-tripit'
    
Then add your API consumer key and secret to your `omniauth.rb` initializer:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :tripit, "your_consumer_key", "your_consumer_secret"
    end