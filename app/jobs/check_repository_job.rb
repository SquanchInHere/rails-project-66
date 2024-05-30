# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(user_id, check_id)
    user = User.find(user_id)
    check = ::Repository::Check.find(check_id)
    check.run_check!

    linter_result = execute_lint(user, check)

    if linter_result[:is_fatal]
      handle_check_status(check, user, linter_result, :fail!, :failed_check_email)
    elsif linter_result[:offense_count].positive?
      handle_check_status(check, user, linter_result, :finish!, :error_check_email)
    else
      handle_check_status(check, user, linter_result, :finish!, :passed_check_email, passed: true)
    end
  end

  private

  def execute_lint(user, check)
    repository = check.repository
    github_client = initialize_github_client(user)
    check.update(commit_id: github_client.get_latest_commit_sha(repository.full_name))

    dir_path = clone_repository(github_client, repository)
    linter = Linters::Handler.new(repository)
    result = linter.exec(dir_path)
    FileUtils.rm_rf(dir_path)
    result
  end

  def initialize_github_client(user)
    AppContainer.resolve(:github_client).new(user.token)
  end

  def clone_repository(github_client, repository)
    dir_path = Rails.root.join("tmp/clone_app/#{repository.id}")
    FileUtils.rm_rf(dir_path)
    github_client.clone_repository(repository, dir_path)
    dir_path
  end

  def handle_check_status(check, user, linter_result, status, email_type, extra_attrs = {})
    check.update(extra_attrs.merge(details: linter_result))
    check.public_send(status)
    send_email(email_type, user, check)
  end

  def send_email(email_type, user, check)
    CheckResultMailer.with(user_id: user.id, repository_id: check.repository.id).public_send(email_type).deliver_later
  end
end
