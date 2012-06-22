require 'omniauth-oauth'

module OmniAuth
  module Strategies
    class Tripit < OmniAuth::Strategies::OAuth

      option :name, 'tripit'
      option :client_options, { :site               => 'https://api.tripit.com',
                                :request_token_path => '/oauth/request_token',
                                :access_token_path  => '/oauth/access_token',
                                :authorize_url      => 'https://www.tripit.com/oauth/authorize' }

      def request_phase
        request_token = consumer.get_request_token({:oauth_callback => callback_url})
        session['oauth'] ||= {}
        session['oauth'][name.to_s] = {'callback_confirmed' => request_token.callback_confirmed?, 
                                       'request_token'      => request_token.token, 
                                       'request_secret'     => request_token.secret}

        if request_token.callback_confirmed?
          redirect request_token.authorize_url(options[:authorize_params])
        else
          redirect request_token.authorize_url(options[:authorize_params].merge(:oauth_callback => callback_url))
        end

      rescue ::Timeout::Error => e
        fail!(:timeout, e)
      rescue ::Net::HTTPFatalError, ::OpenSSL::SSL::SSLError => e
        fail!(:service_unavailable, e)
      end

      
      def urlencode(str)
        str.gsub(/[^a-zA-Z0-9_\.\-]/n) {|s| sprintf('%%%02x', s[0]) }
      end      
    end
  end
end