require 'rubygems'
require 'bundler/setup'
require 'mailgun'

class Notifier

  attr_accessor :mg_obj, :first_name

  def initialize(options = {})
    @first_name = options[:name].split(' ').first
    @mg_obj = Mailgun::MessageBuilder.new
    @mg_obj.add_recipient :to, options[:email]
    @mg_obj.add_recipient :from, options[:sender] || "Makers Academy Sweden - payement gateway <#{ENV['MAILGUN_DEFAULT_SENDER']}>"
    @mg_obj.set_subject options[:subject] || 'Betalning till Makers Academy'
    @mg_obj.set_text_body options[:body] || "Bästa #{@first_name}, \n\n Din betalning har blivit mottagen \n\n Tack så mycket."
    @mg_obj.set_test_mode(mode)
    deliver(@mg_obj)
  end


  def deliver(message)
    m = Mailgun::Client.new(ENV['MAILGUN_API_KEY'])
    m.send_message ENV['MAILGUN_DOMAIN'], message
  end

  private

  def mode
    ENV['RACK_ENV'] == 'production' ? false : true
  end
end

