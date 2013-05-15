require 'spec_helper'

describe Api::V1::CategorizationsController do
  describe "#create" do
    context "with valid categorizations" do
      it "responds with a 201 status"
      it "creates two categorizations if two are specified"
    end

    context "with only invalid categorizations" do
      it "responds with a 422 status"
      it "responds with error messages"
    end

    context "with partial success" do
      it "responds with a 201 status"
      it "provides error mesages for failures"
    end
  end
end
