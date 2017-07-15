require_relative  '../spec_helper'

RSpec.describe Authentication do

  def user_credentials(user, password)
    ENV['COOLPAY_USER'] = user
    ENV['COOLPAY_PASSWORD'] = password
    {
    "username": user,
    "apikey": password
    }
  end

  it 'should have an api url' do
    api_url = 'https://coolpay.herokuapp.com/api/login'
    expect(described_class::BASE_URL).to eq(api_url)
  end

  it 'should have default headers' do
    headers = {
      :content_type => 'application/json'
    }
    expect(described_class.headers).to eq(headers)
  end

  it 'should raise MissingApiKey error' do
    user_credentials(nil, nil)
    expect{described_class.authenticate}.to raise_error(described_class::MissingApiKey)
  end

  it 'should return autrhorization token' do
    token = {"token" => "lkfsjladfjsklfjdslf"}.to_json
    user_credentials('deniss', 'password')
     stub_request(:post, "https://coolpay.herokuapp.com/api/login").
       with(body: {"apikey"=>"password", "username"=>"deniss"},
            headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'31', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'coolpay.herokuapp.com', 'User-Agent'=>'rest-client/2.0.2 (darwin15.2.0 x86_64) ruby/2.3.0p0'}).
       to_return(status: 200, body: token, headers: {})
    expect(described_class.authenticate).to eq(token)
  end

end
