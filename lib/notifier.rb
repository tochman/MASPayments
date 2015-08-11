require 'rubygems'
require 'bundler/setup'
require 'mandrill'

class Notifier

  def deliver(opts = {})
    m = Mandrill::API.new
    first_name = opts[:name].split(' ').first
    message = {
     subject: 'Betalning till Makers Academy',
     from_name: 'Makers Academy Sweden ',
     text: "#{first_name}, \n\n Din betalning har blivit mottagen \n\n Tack så mycket.",
     to: [
       {
         email: opts[:email],
         name: opts[:name]
       }
     ],
     from_email: 'info@makersacademy.se'
    }
    sending = m.messages.send message
    puts sending
  end
end

