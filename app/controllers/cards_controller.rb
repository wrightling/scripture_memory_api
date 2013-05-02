class CardsController < ApplicationController
  def index
    @cards = Card.cards_updated_since(params[:last_updated])

    render json: @cards
  end
end
