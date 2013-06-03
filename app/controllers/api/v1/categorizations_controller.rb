module Api
  module V1
    class CategorizationsController < ApplicationController
      before_action :find_categorization, only: [:show, :destroy]

      def show
        render json: [@categorization], root: "categorizations"
      end

      def index
        @categorizations = Categorization.updated_since(params[:last_updated])

        render json: @categorizations
      end

      def create
        @categorization = Categorization.new(cat_params)

        if @categorization.save
          render json: @categorization, root: "categorizations", status: :created,
            location: api_categorization_url(@categorization, host: HOST)
        elsif Array(@categorization.errors[:base]).first =~ /link.*already exists/
          render json: @categorization.errors, status: :conflict
        else
          render json: @categorization.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @categorization.destroy

        head status: :no_content
      end

      private

      def find_categorization
        @categorization = Categorization.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        error = { error: "The categorization you were looking for could not be found" }
        render json: error, status: :not_found
      end

      def cat_params
        # Hacking here because strong_parameters can't handle #require returning an array yet.
        params_array = Array(params.require(:categorizations))
        ActionController::Parameters.new(params_array.first).permit(:card_id, :category_id)
      end
    end
  end
end
