require 'rails_helper'

RSpec.describe Mentioning, type: :model do
  it { is_expected.to belong_to :mentionable }
  it { is_expected.to belong_to :mention }
end
