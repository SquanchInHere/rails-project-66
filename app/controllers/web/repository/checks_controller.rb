# frozen_string_literal: true

module Web
  module Repository
    class ChecksController < ApplicationController
      before_action :set_check, only: :show
      before_action :set_repository, only: :create

      def show
        authorize @check
        flash.now[:notice] = t('.check_in_progress')

        unless @check.finished? || @check.failed?
          redirect_to @check.repository and return
        end

        render :show
      end

      def create
        check = @repository.checks.create!
        authorize check

        CheckRepositoryJob.perform_now(current_user.id, check.id)

        flash[:notice] = t('.create_success')
        redirect_to @repository
      end

      private

      def set_check
        @check = ::Repository::Check.includes(:repository).find(params[:id])
      end

      def set_repository
        @repository = ::Repository.find(params[:repository_id])
      end
    end
  end
end
