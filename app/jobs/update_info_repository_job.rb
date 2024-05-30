# frozen_string_literal: true

class UpdateInfoRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository, user)
    github_client = github_client_by(user)
    github_client.create_hook(repository)
  rescue StandardError
    'webhook already exist'
  end

  private

  def github_client_by(user)
    github_client_class = AppContainer.resolve(:github_client)
    github_client_class.new(user.token)
  end
end
