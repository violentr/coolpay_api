#!/usr/bin/env ruby

rubygems if RUBY_VERSION < '1.9'
require 'rest_client'
require 'active_support/all'

class Authentication
  BASE_URL = 'https://coolpay.herokuapp.com/api/login'

  def self.authenticate
    raise MissingApiKey if has_no_credentials?
    RestClient.post(BASE_URL, user_credentials, headers)
  end

  def self.headers
  {
    :content_type => 'application/json'
  }

  end

 private

  def self.user_credentials
    {
    "username": ENV["COOLPAY_USER"],
    "apikey": ENV["COOLPAY_PASSWORD"]
    }
  end

  def self.has_no_credentials?
    output = user_credentials.values.map(&:blank?)
    output.include?(true)
  end

  class MissingApiKey < StandardError ; end

end

#auth_token = Client.authenticate
#auth_token["token"]
