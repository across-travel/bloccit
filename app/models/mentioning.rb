class Mentioning < ApplicationRecord
  belongs_to :mention
  belongs_to :mentionable, polymorphic: true
end
