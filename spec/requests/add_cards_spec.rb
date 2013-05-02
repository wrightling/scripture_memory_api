require 'spec_helper'

describe "AddCards" do
  before :each do
    @request_payload = {
      card: {
        subject: 'some subject',
        reference: 'Rom 3:23',
        scripture: 'For all have sinned...'
      }
    }
  end

  it "increases the number of cards" do
    expect { post cards_path, @request_payload }.to change { Card.count }.by(1)
  end

  it "adds a valid card with expected values"
end
