class Payment
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def authorized_headers
    Authentication.headers.merge("Authorization" => "Bearer #{token}")
  end

  def payment_url
    Authentication::BASE_URL + 'payments'
  end

  def list
    JSON.parse(RestClient.get(payment_url, authorized_headers))['payments']
  end

  def is_paid_to?(user_id)
    list.each do |payment|
      if payment["recipient_id"] == user_id
        return "#{payment}"
      else
        return "your user_id: #{user_id} was not found"
      end
    end
  end

  def create(user_id, amount)
    payment = {
      "payment": {
        "amount": amount,
        "currency": "GBP",
        "recipient_id": user_id
      }
    }.to_json
    RestClient.post(payment_url, payment, authorized_headers)
  end

end
