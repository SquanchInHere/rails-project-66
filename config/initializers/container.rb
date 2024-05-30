# frozen_string_literal: true

class AppContainer
  extend Dry::Container::Mixin

  register(:github_client) { Rails.env.test? ? Github::GithubClientStub : Github::GithubClient }
end
