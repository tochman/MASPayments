require 'spec_helper'
require './lib/notifier'


describe Notifier do
  subject { Notifier.new(email: 'thomas@makersacademy.se', name: 'Anders', amount: '100') }
  context 'builds a message' do
    it 'with a recipiant' do
      expect(subject.mg_obj.message[:to]).to include 'thomas@makersacademy.se'
    end

    it 'with a default sender' do
      sender = "Makers Academy Sweden - payement gateway <#{ENV['MAILGUN_DEFAULT_SENDER']}>"
      expect(subject.mg_obj.message[:from]).to include sender
    end

    it 'with a custom sender' do
      notifier = Notifier.new(email: 'thomas@makersacademy.se', name: 'Anders', sender: 'test@sender.com')
      expect(notifier.mg_obj.message[:from]).to include 'test@sender.com'
    end

    it 'with s default subject' do
      expect(subject.mg_obj.message[:subject]).to include 'Betalning till Makers Academy'
    end

    it 'with a custom subject' do
      notifier = Notifier.new(email: 'thomas@makersacademy.se', name: 'Anders', subject: 'My custom subject')
      expect(notifier.mg_obj.message[:subject]).to include 'My custom subject'
    end

    it 'with a default body' do
      expect(subject.mg_obj.message[:text]).to include "Bästa Anders, \n\n Din betalning har blivit mottagen \n\n Tack så mycket."
    end

    it 'with a custom body' do
      notifier = Notifier.new(email: 'thomas@makersacademy.se', name: 'Anders', body: 'My custom body')
      expect(notifier.mg_obj.message[:text]).to include 'My custom body'
    end
  end


  it 'adds message to que' do
    action = subject.deliver(subject.mg_obj)
    expect(action.body).to include 'Queued. Thank you.'
  end
end


#describe "Billing Events" do
#def stub_event(fixture_id, json_file = nil)
#json_file ||= fixture_id
#stub_request(:get, "https://api.stripe.com/v1/events/#{fixture_id}").
#to_return(:status => 200, :body => '{"id"=>"evt_customer_created", "created"=>1384544738, "livemode"=>false, "type"=>"customer.created", "data"=>{"object"=>{"object"=>"customer", "created"=>1384544738, "id"=>"cus_2wm5EgmRGEiyPO", "livemode"=>false, "description"=>"id:12345", "email"=>"user@example.com", "delinquent"=>false, "metadata"=>{}, "subscription"=>nil, "discount"=>nil, "account_balance"=>0, "cards"=>{"object"=>"list", "count"=>0, "url"=>"/v1/customers/cus_2wm5EgmRGEiyPO/cards", "data"=>[]}, "default_card"=>nil, "next_recurring_charge"=>nil, "active_card"=>nil}}, "object"=>"event", "pending_webhooks"=>1, "request"=>"iar_2wm5M67yu99gVP"}')
#end

#describe "customer.created" do
#before do
#stub_event 'evt_customer_created'
#end

#it "is successful" do
#post '/_billing_events', id: 'evt_customer_created'
#p last_response
#last_response.should be_ok
##expect(Notifier).to_recieve(:deliver)
#end
#end
#end
