module Api
  module V1
    class CategorizationsController < ApplicationController
      def index
        @categorizations = Categorization.updated_since(params[:last_updated])

        render json: @categorizations
      end

      def create
        @categorization = Categorization.new(Array(params[:categorizations]).first)

        if @categorization.save
          render json: @categorization, root: "categorizations", status: :created
        elsif Array(@categorization.errors[:base]).first =~ /link.*already exists/
          render json: @categorization.errors, status: :conflict
        else
          render json: @categorization.errors, status: :unprocessable_entity
        end
      end

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
