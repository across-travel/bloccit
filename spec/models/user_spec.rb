require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:topic) { create(:topic) }
  let(:second_user) { create(:user) }

  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_many(:votes) }

  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_length_of(:username).is_at_least(1) }
  it { is_expected.to validate_uniqueness_of(:username) }
  it { is_expected.to allow_value("@admin_user123").for(:username) }

  # Shoulda tests for name
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(1) }

  # Shoulda tests for email
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_least(3) }
  it { is_expected.to allow_value("user@bloccit.com").for(:email) }

  # Shoulda tests for password
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  describe "attributes" do

    it "should have name and email attributes" do
      expect(user).to have_attributes(name: user.name, email: user.email, username: user.username)
    end

    it "responds to role" do
      expect(user).to respond_to(:role)
    end

    it "responds to admin?" do
      expect(user).to respond_to(:admin?)
    end

    it "responds to member?" do
      expect(user).to respond_to(:member?)
    end

  end

  describe "roles" do

    it "is member by default" do
      expect(user.role).to eq("member")
    end

    context "member user" do

      it "returns true for #member?" do
        expect(user.member?).to be_truthy
      end

      it "returns false for #admin?" do
        expect(user.admin?).to be_falsey
      end

    end

    context "admin user" do

      before do
        user.admin!
      end

      it "returns false for #member?" do
        expect(user.member?).to be_falsey
      end

      it "returns true for #admin?" do
        expect(user.admin?).to be_truthy
      end

    end

  end

  describe "invalid user" do
    let(:user_with_invalid_name) { build(:user, name: "") }
    let(:user_with_invalid_email) { build(:user, email: "") }

    it "should be an invalid user due to blank name" do
      expect(user_with_invalid_name).to_not be_valid
    end

    it "should be an invalid user due to blank email" do
      expect(user_with_invalid_email).to_not be_valid
    end
  end

  describe ".avatar_url" do
    let(:known_user) { create(:user, email: "blochead@bloc.io") }

    it "returns the proper Gravatar url for a known email entity" do
      expected_gravatar = "http://gravatar.com/avatar/bb6d1172212c180cfbdb7039129d7b03.png?s=48"
      expect(known_user.avatar_url(48)).to eq(expected_gravatar)
    end
  end

  describe "#generate_auth_token" do
    it "creates a token" do
      expect(user.auth_token).to_not be_nil
    end
  end

  describe "following and unfollowing" do
    it "should follow another user" do
      user.follow(second_user)
      expect(user.following?(second_user)).to be_truthy
    end

    it "should unfollow another user" do
      user.follow(second_user)
      user.unfollow(second_user)
      expect(user.following?(second_user)).to be_falsey
    end

    it "checks whether one user follows another user" do
      user.follow(second_user)
      expect(second_user.followers.include?(user)).to be_truthy
    end
  end

  describe "subscribing" do
    it "should subsribe to a topic" do
      user.subscribe(topic)
      expect(user.subscribed_to?(topic)).to be_truthy
    end

    it "should unsubsribe to a topic" do
      user.subscribe(topic)
      user.unsubscribe(topic)
      expect(user.subscribed_to?(topic)).to be_falsey
    end
  end

end
