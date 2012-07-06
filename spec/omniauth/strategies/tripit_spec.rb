require 'spec_helper'

describe OmniAuth::Strategies::Tripit do
  subject do
    OmniAuth::Strategies::Tripit.new({})
  end

  context "client options" do
    it 'should have correct name' do
      subject.options.name.should eq("tripit")
    end

    it 'should have correct site' do
      subject.options.client_options.site.should eq('https://api.tripit.com')
    end

    it 'should have the correct request token path' do
      subject.options.client_options.request_token_path.should eq('/oauth/request_token')
    end

    it 'should have the correct access token path' do
      subject.options.client_options.access_token_path.should eq('/oauth/access_token')
    end

    it 'should have correct authorize url' do
      subject.options.client_options.authorize_url.should eq('https://www.tripit.com/oauth/authorize')
    end
  end
end
