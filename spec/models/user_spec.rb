# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com"}
end

  it "Should create a new instance given valid details" do
    User.create!(@attr)
end
  it "Should require a name" do
    long_name = 'a' * 51
    no_name_user = User.new(@attr.merge(:name => long_name))
    no_name_user.should_not be_valid
  end
  it "Should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  it "Should reject invalid email addresses" do
    addresses = %w[user@foot,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
    invalid_email_user = User.new(@attr.merge(:email => address))
    invalid_email_user.should_not be_valid
    end
  end
  it "Should reject duplicate email address" do
    #put a user with given email address into the database
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  it "Should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
end