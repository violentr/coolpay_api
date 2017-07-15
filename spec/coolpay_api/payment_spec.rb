require_relative  '../spec_helper'

RSpec.describe Payment do
  let(:payment) {Payment.new("token")}

  it 'should be initialized with token' do
    expect(payment.token).to be
  end
  it 'should have payment_url ' do
    url = 'https://coolpay.herokuapp.com/api/payments'
    expect(payment.payment_url).to eq(url)
  end
  it 'should have authorized headers' do
    headers = {
      :content_type => 'application/json',
    "Authorization" => "Bearer token"
    }
    expect(payment.authorized_headers).to eq(headers)
  end

  it 'should list all made payments' do
    output = {"status"=>"paid", "recipient_id"=>"b8470c4d-2871-4fb3-b3cc-552ff1622be1", "id"=>"f85a12bf-683a-428b-bb62-79ddba1222a5", "currency"=>"GBP", "amount"=>"40"}
     stub_request(:get, "https://coolpay.herokuapp.com/api/recipients").
       with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer token', 'Content-Type'=>'application/json', 'Host'=>'coolpay.herokuapp.com', 'User-Agent'=>'rest-client/2.0.2 (darwin15.2.0 x86_64) ruby/2.3.0p0'}).
       to_return(status: 200, body: output.to_json, headers: {})
     allow_any_instance_of(Payment).to receive(:list).and_return(output)
    expect(payment.list).to eq(output)
  end

  it 'should create payment' do
    output = {"recipient":{"name":"deniss","id":"875668fb-1821-46fd-b424-f03b7efb4ba2"}}
    paid_amount = 100
     stub_request(:get, "https://coolpay.herokuapp.com/api/recipients").
       with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer token', 'Content-Type'=>'application/json', 'Host'=>'coolpay.herokuapp.com', 'User-Agent'=>'rest-client/2.0.2 (darwin15.2.0 x86_64) ruby/2.3.0p0'}).
       to_return(status: 200, body: output.to_json, headers: {})
     allow_any_instance_of(Payment).to receive(:create).with('darja', paid_amount).and_return(output)
    expect(payment.create('darja', paid_amount)).to eq(output)
  end
end
