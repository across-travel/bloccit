require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { Question.create!(title: "My Question", body: "The Text", resolved: false) }

  describe "attributes" do
  	it "has title, body and resolved attributes" do
  		expect(question).to have_attributes(title: "My Question", body: "The Text", resolved: false)
  	end
  end
end
