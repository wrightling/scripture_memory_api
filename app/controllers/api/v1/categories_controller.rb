module Api
  module V1
    class CategoriesController < ApplicationController
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

      # def update
      #   @category = Category.find(params[:id])

      #   if @category.update_attributes(params[:category])
      #     head :no_content
      #   else
      #     render json: @category.errors, status: :unprocessable_entity
      #   end
      # end

      # def destroy
      #   @category = Category.find(params[:id])
      #   @category.destroy

      #   head :no_content
      # end
    end
  end
end
