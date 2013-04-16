require 'spec_helper'

describe "RetrieveCards" do
  before :each do
    Card.create(reference: 'Rom 3:23', scripture: 'all have sinned', subject: '')
    Card.create(reference: 'Rom 6:23', scripture: 'the wages of sin is death', subject: '')
  end

  it "should retrieve all cards" do
  end
end
