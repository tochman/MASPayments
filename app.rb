require 'json'
require 'sinatra'
require 'stripe'
require 'stripe_event'
require 'haml'
require 'logger'
require 'money'
require 'dotenv'
require 'mailgun'
require 'rack/ssl-enforcer'
require 'pry'


require_relative 'lib/notifier'

module AppHelpers
  def products
    [{value: '740000', text: 'Anmälningsavgift 7400 SEK'},
     {value: '7400000', text: 'Full kursavgift 74 000 SEK'},
     {value: '6660000', text: 'Tidig betalning full kursavgift (-10%) 66 600 SEK'}]
  end

  def years_range
    (2015..2025)
  end

  def months_range
    (1..12)
  end
end


class MASPayment < Sinatra::Base
  Dotenv.load
  Stripe.api_key = ENV['STRIPE_API_KEY']

  configure :production do
    set :host, 'payment.makersacademy.se'
    set :force_ssl, true
    use Rack::SslEnforcer
  end

  set :root, File.dirname(__FILE__)
  set :views, 'views'
  set :public_folder, 'public'

  get '/' do
    haml :index
  end

  get '/payment' do
    haml :form, locals: {products: products}
  end

  post '/pay' do
    amount = params[:amount].to_i
    customer = Stripe::Customer.create(
        email: params[:email],
        card: params[:stripeToken],
        metadata: {
            name: params[:cc_name],
            address: params[:address],
            city: params[:city],
            state: params[:state],
            zip: params[:zip]
        }
    )
    @charge = Stripe::Charge.create(
        amount: amount,
        currency: 'sek',
        customer: customer.id,
        description: 'Makers Academy - kursavgift'
    )
    Thread.new { Notifier.new(email: params[:email], name: params[:name], amount: params[:amount]) }
    haml :confirmation
  end

  helpers do
    include AppHelpers
  end
end



