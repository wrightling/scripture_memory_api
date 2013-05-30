module Api
  module V1
    class CollectionshipsController < ApplicationController
      before_filter :find_collectionship, only: [:show, :destroy]

      def show
        render json: [@collectionship], root: "collectionships"
      end

      def index
        @collectionships = Collectionship.updated_since(params[:last_updated])

        render json: @collectionships
      end

      def create
        @collectionship = Collectionship.new(ship_params)

        if @collectionship.save
          render json: @collectionship, root: "collectionships", status: :created,
            location: api_collectionship_url(@collectionship, host: HOST)
        elsif Array(@collectionship.errors[:base]).first =~ /link.*already exists/
          render json: @collectionship.errors, status: :conflict
        else
          render json: @collectionship.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @collectionship.destroy

        head status: :no_content
      end

      private

      def find_collectionship
        @collectionship = Collectionship.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        error = { error: "The collectionship you were looking for could not be found" }
        render json: error, status: :not_found
      end

      def ship_params
        params_array = Array(params.require(:collectionships))
        ActionController::Parameters.new(params_array.first).permit(:card_id, :collection_id)
      end
    end
  end
end
