require_relative '../spec_helper'

describe 'the application' do
  describe 'homepage', type: :feature, js: true do
  end

  describe 'successful charge', type: :feature, js: true do
    it 'works' do
      visit '/payment'
      fill_in 'email', with: 'validemail@example.com'
      fill_in 'name', with: 'FakeName'
      fill_in 'address', with: '123 Fake St.'
      fill_in 'city', with: 'Seattle'
      fill_in 'zip', with: '98109'
      select 'Full kursavgift (-10%) 66 600 SEK', from: 'amount'
      fill_in 'cc_name', with: 'FakeName'
      fill_in 'card-number', with: '4242424242424242'
      fill_in 'cc-cvc', with: '222'
      within('#expiry') do
        select '2', from: 'expiration-month'
        select '2015', from: 'expiration-year'
      end
      #save_and_open_page
      click_button 'Skicka'
      binding.pry
      puts response
      find('.thank-you') do
        expect(page).to have_content 'Thanks'
        expect(page).to have_content '$14.00'
      end
    end
  end

  describe 'failed charge', type: :feature, js: true do
    it 'checkout' do
      visit '/payment'
      click_button 'Skicka'
      expect(page).to have_content 'This value is required'
    end
  end
end
