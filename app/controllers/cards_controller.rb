class CardsController < ApplicationController
  def index
    @cards = Card.updated_since(params[:last_updated])

    render json: @cards
  end
end
