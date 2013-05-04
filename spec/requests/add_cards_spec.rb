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

    post '/api/cards', @request_payload,
      {'HTTP_ACCEPT' => 'application/smapi.v1'}
  end

  it "has a status code of 201" do
    response.response_code.should eql 201
  end

  it "increases the number of cards" do
    Card.count.should eql 1
  end

  it "adds a valid card with expected values" do
    Card.last.subject.should eql @request_payload[:card][:subject]
  end
end
