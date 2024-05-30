# frozen_string_literal: true

module Web
  module Repository
    class RepositoriesController < ApplicationController
      before_action :authenticate_user!, :set_github_client
      before_action :set_repository, only: :show

      def index
        @repositories = current_user.paginated_repositories params[:page]
      end

      def show
        authorize @repository
        @checks = @repository.paginate_check params[:page]
      end

      def new
        @repository = current_user.repositories.build
        authorize @repository
        @repositories = fetch_github_repositories
      end

      def create
        @repository = current_user.repositories.find_or_initialize_by(repository_params)
        authorize @repository

        if @repository.save
          UpdateInfoRepositoryJob.perform_now(@repository, current_user)
          redirect_to repositories_path, notice: t('.create_success')
        else
          flash[:alert] = @repository.errors.full_messages.to_sentence
          render :new
        end
      end

      private

      def repository_params
        params.require(:repository).permit(:github_id)
      end

      def set_repository
        @repository = ::Repository.find(params[:id])
      end

      def set_github_client
        @github_client = AppContainer.resolve(:github_client).new(current_user.token)
      end

      def fetch_github_repositories
        cache_key = "#{current_user.cache_key_with_version}/github_repositories"
        Rails.cache.fetch(cache_key, expires_in: 12.hours) do
          @github_client.repos_collection(current_user)
        end
      end
    end
  end
end
