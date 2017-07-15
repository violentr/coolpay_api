#!/usr/bin/env ruby

rubygems if RUBY_VERSION < '1.9'
require 'rest_client'
require_relative 'recipient'
require 'active_support/all'

module Authentication
  BASE_URL = 'https://coolpay.herokuapp.com/api/'.freeze

  def self.authenticate
    raise MissingApiKey if has_no_credentials?
    response = RestClient.post(authentication_url, user_credentials, headers)
    JSON.parse(response.body)["token"]
  end


  def self.authentication_url
    BASE_URL + 'login'
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


