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

  context "uid" do
    it "should fetch the profile ref from the profile hash" do
      profile_ref = 'abcdefg'
      subject.should_receive(:profile).and_return('@attributes' => { 'ref' => profile_ref })

      subject.uid.should eq(profile_ref)
    end
  end

  context "info" do
    it "should fetch the email address (info['email']) from profile_email and the screen_name (info['nickname']) from the profile hash" do
      email = 'bob@jones.com'
      subject.should_receive(:profile_email).and_return(email)
      screen_name = 'bob1234'
      subject.should_receive(:profile).and_return('screen_name' => screen_name)

      info = subject.info
      info['email'].should eq(email)
      info['nickname'].should eq(screen_name)
    end
  end

  context "extra" do
    it "should fetch the entire profile info (extra['raw_info'])" do
      profile = { 'some' => 'hash' }
      subject.should_receive(:profile).and_return(profile)

      subject.extra['raw_info'].should eq(profile)
    end
  end

  context "#profile_email" do
    it "should fetch the email address from the profile hash, if there is only one email" do
      email = 'bob@jones.com'
      profile = { 'ProfileEmailAddresses' => { 'ProfileEmailAddress' => { 'address' => email } } }
      subject.should_receive(:profile).and_return(profile)

      subject.profile_email.should eq(email)
    end

    it "should fetch the primary address from the profile hash, if there are many email addresses" do
      primary_email = 'bob@jones.com'
      profile = { 'ProfileEmailAddresses' => { 'ProfileEmailAddress' => [
          { 'address' => 'not.the@one.com', 'is_primary' => 'false' },
          { 'address' => primary_email, 'is_primary' => 'true' }
      ] } }
      subject.should_receive(:profile).and_return(profile)

      subject.profile_email.should eq(primary_email)
    end
  end

  context "#profile" do
    it "should fetch the profile json using the access token and parse it" do
      profile_json = '{ "some": "hash" }'
      response = double()
      response.should_receive(:body).and_return(profile_json)
      access_token = double()
      access_token.should_receive(:get).with('/v1/get/profile/format/json').and_return(response)
      subject.should_receive(:access_token).and_return(access_token)
      profile = double()
      profile.should_receive(:[]).with('Profile')
      MultiJson.should_receive(:load).with(profile_json).and_return(profile)

      subject.profile
    end
  end
end
