require 'rails_helper'

RSpec.describe Advertisement, type: :model do
  let(:advertisement) { Advertisement.create!(title: "My title", body: "My body", price: 4) }

  describe "attributes" do
  	it "has title, body and price attributes" do
  		expect(advertisement).to have_attributes(title: "My title", body: "My body", price: 4)
  	end
  end
end
