class Invite < ApplicationRecord
  require 'twilio-ruby'

  belongs_to :user

  before_save { self.email = email.downcase if email.present? }

  validates :email,
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i },
            length: { minimum: 3, maximum: 254 },
            allow_blank: true

  validates :phone,
          format: { with: /\A[+]\d+\z/ },
          length: { minimum: 3, maximum: 25 },
          allow_blank: true

  after_save do
    unless self.email.empty?
      InviteMailer.invite_user(self, self.user).deliver_now
    end
    unless self.phone.empty?
      account_sid = "AC06a7675f8463b81e262cc9ede3edf07f" # Your Account SID from www.twilio.com/console
      auth_token = ENV['TWILIO_AUTH_TOKEN']   # Your Auth Token from www.twilio.com/console

      binding.pry
      begin
          @client = Twilio::REST::Client.new account_sid, auth_token
          message = @client.messages.create(
              body: "#{self.user.email} has invited you to join bloccit https://limitless-beach-68539.herokuapp.com/users/new",
              to: self.phone,    # Replace with your phone number
              from: "+441772367546")  # Replace with your Twilio number
      rescue Twilio::REST::TwilioError => e
          puts e.message
      end
    end
  end
end
