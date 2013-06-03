module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :find_category, only: [:show, :update, :destroy]

      def show
        render json: [@category], root: "categories"
      end

      def index
        @categories = Category.updated_since(params[:last_updated])

        render json: @categories
      end

      def create
        @category = Category.new(category_params)

        if @category.save
          render json: @category, root: "categories", status: :created,
            location: api_category_url(@category, host: HOST)
        else
          errors = { errors: @category.errors.full_messages }
          render json: errors, status: :unprocessable_entity
        end
      end

      def update
        @category.update(category_params)
      end

      def destroy
        @category.destroy

        head status: :no_content
      end

      private

      def find_category
        @category = Category.find(params["id"])
      rescue
        error = { error: 'The category you were looking for could not be found' }
        render json: error, status: 404
      end

      def category_params
        # Hacking here because strong_parameters can't handle #require returning an array yet.
        params_array = Array(params.require(:categories))
        ActionController::Parameters.new(params_array.first).permit(:name)
      end
    end
  end
end
