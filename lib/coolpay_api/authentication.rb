#!/usr/bin/env ruby

rubygems if RUBY_VERSION < '1.9'
require 'rest_client'
require_relative 'recipient'
require_relative 'payment'
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

unless ENV['TEST'] == 'test'
  token = Authentication.authenticate
  recipient = Recipient.new(token)
  payment = Payment.new(token)
  puts " \t Welcome to the payment terminal\n "
  puts " \t Please choose letter [t,l,c,r]:"

  puts " \t #########################"
  puts " \t # t: create recipient"
  puts " \t # l: list recipients"
  puts " \t # r: create payment"
  puts " \t # c: check payment status"
  puts " \t # x: exit"
  puts " \t #########################"
  input = gets.chomp

  case input
  when 't'
    puts "Create recipient please enter name:"
    user_name = gets.chomp
    recipient.create(user_name)
  when 'l'
    puts recipient.list
  when 'c'
    puts "Check what paid to user, enter user_id:"
    user_id = gets.chomp
    puts payment.is_paid_to?(user_id)
  when 'r'
    puts "Please enter user id:"
    user_id = gets.chomp
    puts "Please enter amount:"
    paid_amount = gets.chomp
    payment.create(user_id, paid_amount)
  when 'x'
    puts "Thank you for using payment terminal"
  end
end
