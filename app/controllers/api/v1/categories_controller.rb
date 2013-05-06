module Api
  module V1
    class CategoriesController < ApplicationController
      before_filter :find_category, only: [:update]

      def index
        @categories = Category.updated_since(params[:last_updated])

        render json: @categories
      end

      def create
        @category = Category.new(params["category"])

        if @category.save
          render json: @category, status: :created
        else
          errors = { errors: @category.errors.full_messages }
          render json: errors, status: :unprocessable_entity
        end
      end

      def update
        @category.update_attributes(params["category"])
      end

      # def destroy
      #   @category = Category.find(params[:id])
      #   @category.destroy

      #   head :no_content
      # end

      private

      def find_category
        @category = Category.find(params["id"])
      rescue
        error = { error: 'The category you were looking for could not be found' }
        render json: error, status: 404
      end
    end
  end
end
