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
    @attr = { :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "Should create new user given valid attributes" do
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
describe "Password encryption" do

  before(:each) do
    @attr = { :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
    @user = User.create!(@attr)
  end
  it "Should have an encrypted password" do
    @user.should respond_to :encrypted_password
  end
  it "Should set the encrypted password" do
    @user.encrypted_password.should_not be_blank
  end
end

describe "has_password? method" do

  before(:each) do
    @attr = { :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
    @user = User.create!(@attr)
  end

  it "Should be true if the passwords match" do
    @user.has_password?("Invalid").should be_false
  end
end

describe "Password validations" do

  before(:each) do
    @attr = { :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "Should require a password" do
    User.new(@attr.merge(:password => "", :password_confirmation => "")).
    should_not be_valid
  end

  it "Should require a matching password confirmation" do
    User.new(@attr.merge(:password_confirmation=>"invalid")).
    should_not be_valid
  end

  it "Should reject short passwords" do
    short = 'a' * 5
    hash = @attr.merge(:password => short, :password_confirmation => short)
    User.new(hash).should_not be_valid
  end

  it "should reject long passwords" do
    long = 'a' * 41
    hash = @attr.merge(:password => long, :password_confirmation => long)
    User.new(hash).should_not be_valid
  end
end

describe "authenticate method" do
    before(:each) do
    @attr = { :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
    @user = User.create!(@attr)
  end
  
  it "should return nil on email/password mismatch" do
    wrong_password_user = User.authenticate(@attr[:email], "wrongpassword")
    wrong_password_user.should be_nil
  end
  it "should return nil for an email address with no user" do
    wrong_email_user = User.authenticate("bar@foo.com", @attr[:password])
    wrong_email_user.should be_nil
  end
  it "should return user on email/password match" do
    valid_user = User.authenticate(@attr[:email], @attr[:password])
    valid_user.should == @user
  end
end
