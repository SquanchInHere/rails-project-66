# frozen_string_literal: true

module Github
  class GithubClientStub
    REPOSITORY = {
      id: 123_456_789,
      ssh_url: 'git@github.com:SquanchInHere/testmod.git',
      name: 'testmod',
      full_name: 'SquanchInHere/testmod',
      language: 'ruby',
      clone_url: 'https://github.com/SquanchInHere/testmod.git'
    }.freeze

    REPOS_COLLECTION = [
      { github_id: 123_456_789 },
      { github_id: 987_654_321 },
      { github_id: 112_233_445 },
      { github_id: 556_677_889 }
    ].freeze

    def initialize(access_token)
      @client = Octokit::Client.new(access_token:, auto_paginate: true)
    end

    def repos
      [REPOSITORY]
    end

    def get_latest_commit_sha(_rep_full_name)
      'random_commit_hash'
    end

    def clone_repository(_repository, dir_path)
      FileUtils.mkdir_p(dir_path)
    end

    def find_instance_repository(github_id)
      Repository.find_by(github_id: github_id&.to_i)
    end

    def repos_collection(_user)
      REPOS_COLLECTION
    end

    def repository_params(github_repo_id)
      REPOSITORY.merge(github_id: github_repo_id)
    end
  end
end
