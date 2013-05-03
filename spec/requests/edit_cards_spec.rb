require 'spec_helper'

describe "EditCards" do
  before :each do
    @card1 = FactoryGirl.create(:card)

    @request_payload = {
      card: {
        reference: 'John 5:24'
      }
    }
  end

  let(:edit_reference) { put "/api/cards/#{@card1.id}",
                           @request_payload,
                           {'HTTP_ACCEPT' => "application/smapi.v1"}}

  it "has a status code of 200" do
    edit_reference
    response.response_code.should eql 200
  end

  it "has no effect on the number of cards present" do
    expect { edit_reference }.not_to change { Card.count }
  end

  it "edits the reference to a new value" do
    expect { edit_reference }.to change {
      Card.find(@card1.id).reference
    }.to(@request_payload[:card][:reference])
  end
end
