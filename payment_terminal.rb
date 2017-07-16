#!/usr/bin/env ruby
require './dependencies'

class PaymentTerminal
  attr_reader :token, :recipient, :payment

  def initialize
    @token = Authentication.authenticate
    @recipient = Recipient.new(token)
    @payment = Payment.new(token)
  end

  def process
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

  def display_options
    puts " \t Welcome to the payment terminal\n "
    puts " \t Please choose letter [t,l,c,r]:"

    puts " \t #########################"
    puts " \t # t: create recipient"
    puts " \t # l: list recipients"
    puts " \t # r: create payment"
    puts " \t # c: check payment status"
    puts " \t # x: exit"
    puts " \t #########################"
  end

end

payment_terminal = PaymentTerminal.new
payment_terminal.display_options
payment_terminal.process
