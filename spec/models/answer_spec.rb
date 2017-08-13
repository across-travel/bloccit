require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { Question.create!(title: "My Question", body: "The Text", resolved: true) }
  let(:answer) { Answer.create!(body: "My Answer", question: question) }

  describe "attributes" do
  	it "has body and question attributes" do
  		expect(answer).to have_attributes(body: "My Answer")
  	end
  end
end
