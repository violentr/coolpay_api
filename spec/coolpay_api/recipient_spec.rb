require_relative  '../spec_helper'

RSpec.describe Recipient do
  let(:recipient) {Recipient.new("token")}

  it 'should be initialized with token ' do
    expect(recipient.token).to be
  end
  it 'should have recipients url ' do
    url = 'https://coolpay.herokuapp.com/api/recipients'
    expect(recipient.recipient_url).to eq(url)
  end
  it 'should have authorized headers' do
    headers = {
      :content_type => 'application/json',
    "Authorization" => "Bearer token"
    }
    expect(recipient.authorized_headers).to eq(headers)
  end

  it 'should list all users' do
    output = {"recipients":[]}
     stub_request(:get, "https://coolpay.herokuapp.com/api/recipients").
       with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer token', 'Content-Type'=>'application/json', 'Host'=>'coolpay.herokuapp.com', 'User-Agent'=>'rest-client/2.0.2 (darwin15.2.0 x86_64) ruby/2.3.0p0'}).
       to_return(status: 200, body: output.to_json, headers: {})
     allow_any_instance_of(Recipient).to receive(:list).and_return(output)
    expect(recipient.list).to eq(output)
  end

  it 'should create user ' do
    output = {"recipient":{"name":"deniss","id":"875668fb-1821-46fd-b424-f03b7efb4ba2"}}
     stub_request(:get, "https://coolpay.herokuapp.com/api/recipients").
       with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer token', 'Content-Type'=>'application/json', 'Host'=>'coolpay.herokuapp.com', 'User-Agent'=>'rest-client/2.0.2 (darwin15.2.0 x86_64) ruby/2.3.0p0'}).
       to_return(status: 200, body: output.to_json, headers: {})
     allow_any_instance_of(Recipient).to receive(:create).with('deniss').and_return(output)
    expect(recipient.create('deniss')).to eq(output)
  end
end
