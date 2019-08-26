require 'rails_helper'
RSpec.describe "When I checkout" do
  describe "As a visitor" do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @order = (visit item_path(@chain.id)
                click_on "Add To Cart"
                visit item_path(@tire.id)
                click_on "Add To Cart"
                visit "/cart"

                click_on "Checkout"

                name = "Leiya Kelly"
                address = '11 ILiveAtTuring Ave.'
                city = "Denver"
                state = "CO"
                zip = 80237

                fill_in :name, with: name
                fill_in :address, with: address
                fill_in :city, with: city
                fill_in :state, with: state

                fill_in :zip, with: zip
                click_on "Create Order")

    end
    it "I see a flash message with a randomly generated, 10 digit verification code associated with that order" do

      expect(page).to have_content("Here is your verification code for this order! #{@order.verification_code}")

    end

    it "I can use that verification code to search for an order through the nav bar." do

    end

    it "If an order is found, I am redirected to a verified order page ('/verified_order')" do

    end

    it "On that verified order page, I can: click a link to delete the order,
    update the shipping address for an order, remove items from the order" do

    end
  end
end
