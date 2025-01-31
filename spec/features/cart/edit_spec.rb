require 'rails_helper'

RSpec.describe "Updating Cart" do
  describe "should empty the cart" do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 4)
      @lights = @bike_shop.items.create!(name: "Bike Lights", description: "So bright!", price: 25, image: "https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwiW-NjQv6HkAhUCt54KHYLkAJwQjRx6BAgBEAQ&url=https%3A%2F%2Fwww.amazon.com%2FCycle-Torch-Bolt-Combo-Rechargeable%2Fdp%2FB01N2HZV9U&psig=AOvVaw36ygs9M0LDALlZHfp40GLF&ust=1566941906310951", inventory: 0)
    end

    it "I cannot add something with no inventory to my cart, and get a flash message when I try to do so." do
      visit item_path(@lights.id)
      click_on "Add To Cart"

      expect(page).to have_content("You cannot add any more Bike Lights to your cart.")
    end

    it "When I have items in my cart and I visit my cart, next to each item in my cart, I see a button or link to remove that item from my cart" do
      visit item_path(@chain.id)
      click_on "Add To Cart"
      visit item_path(@tire.id)
      click_on "Add To Cart"
      visit "/cart"
      within "#item-#{@chain.id}" do
        expect(page).to have_link("Remove From Cart")
      end
      within "#item-#{@tire.id}" do
        expect(page).to have_link("Remove From Cart")
      end
    end

    it "Clicking this button will remove the item but not other items" do
      visit item_path(@chain.id)
      click_on "Add To Cart"
      visit item_path(@tire.id)
      click_on "Add To Cart"
      visit "/cart"
      within "#item-#{@chain.id}" do
        click_link("Remove From Cart")
      end
      expect(page).not_to have_content(@chain.name)
      within "#item-#{@tire.id}" do
        click_link("Remove From Cart")
      end
      expect(page).not_to have_content(@tire.name)
    end

    it "When I have items in my cart, and I visit my cart. Next to each item in my cart,
    I see a button or link to increment the count of items I want to purchase,
    I cannot increment the count beyond the item's inventory size" do

    visit item_path(@chain.id)
    click_on "Add To Cart"
    visit item_path(@tire.id)
    click_on "Add To Cart"
    visit "/cart"

    click_on "Add Another Chain"

      within "#item-#{@chain.id}" do
        expect(page).to have_content("Total Quantity: 2")
      end
    expect(current_path).to eq(cart_path)

    click_on "Add Another Gatorskins"

      within "#item-#{@tire.id}" do
        expect(page).to have_content("Total Quantity: 2")
      end

      click_on "Add Another Gatorskins"
      click_on "Add Another Gatorskins"
      click_on "Add Another Gatorskins"

      expect(page).to have_content("You cannot add any more Gatorskins to your cart.")
    end

    it "Next to each item in my cart, I see a button or link to decrement the
    count of items I want to purchase, If I decrement the count to 0 the
    item is immediately removed from my cart" do

      visit item_path(@chain.id)
      click_on "Add To Cart"
      visit item_path(@tire.id)
      click_on "Add To Cart"
      visit "/cart"

      click_on "Add Another Chain"
      click_on "Add Another Gatorskins"
      click_on "Add Another Chain"
      click_on "Add Another Gatorskins"

      click_on "Remove One Chain"
        within "#item-#{@chain.id}" do
          expect(page).to have_content("Total Quantity: 2")
        end

      click_on "Remove One Gatorskins"
        within "#item-#{@tire.id}" do
          expect(page).to have_content("Total Quantity: 2")
        end

      click_on "Remove One Gatorskins"
      click_on "Remove One Gatorskins"

      expect(page).to_not have_content("Gatorskins")
    end

    it "I can empty my cart" do
      visit item_path(@chain.id)
      click_on "Add To Cart"
      visit item_path(@tire.id)
      click_on "Add To Cart"
      visit "/cart"

      click_on "Empty Cart"
      expect(current_path).to eq("/cart")
      expect(page).to_not have_content(@chain.name)
      expect(page).to_not have_content(@tire.name)

    end
  end
end
