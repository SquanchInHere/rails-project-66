# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.test_mode = true if Rails.env.test?

  provider :github, ENV.fetch('GITHUB_CLIENT_ID', nil), ENV.fetch('GITHUB_CLIENT_SECRET', nil),
           scope: 'user,public_repo,admin:repo_hook'
end
