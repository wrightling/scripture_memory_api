module Api
  module V1
    class CategorizationsController < ApplicationController
      def index
        @categorizations = Categorization.updated_since(params[:last_updated])

        render json: @categorizations
      end

      # def create
      #   @categorization = Categorization.new(params[:categorization])

      #   if @categorization.save
      #     render json: @categorization, status: :created, location: @categorization
      #   else
      #     render json: @categorization.errors, status: :unprocessable_entity
      #   end
      # end

      # def update
      #   @categorization = Categorization.find(params[:id])

      #   if @categorization.update_attributes(params[:categorization])
      #     head :no_content
      #   else
      #     render json: @categorization.errors, status: :unprocessable_entity
      #   end
      # end

      # def destroy
      #   @categorization = Categorization.find(params[:id])
      #   @categorization.destroy

      #   head :no_content
      # end
    end
  end
end