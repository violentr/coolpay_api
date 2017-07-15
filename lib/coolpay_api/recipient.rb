class Recipient
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def authorized_headers
    Authentication.headers.merge("Authorization" => "Bearer #{token}")
  end

  def recipient_url
    Authentication::BASE_URL + 'recipients'
  end

  def list
    response = RestClient.get(recipient_url, authorized_headers)
    JSON.parse(response)["recipients"]
  end

  def create(user)
    user = {
      "recipient": {
          "name": user
            }
      }.to_json
    RestClient.post(recipient_url, user, authorized_headers)
  end

end
