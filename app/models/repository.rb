# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, class_name: 'Repository::Check', dependent: :destroy

  enumerize :language, in: %w[ruby javascript]

  validates :github_id, uniqueness: true, presence: true

  def paginate_check(page)
    checks.order(created_at: :desc)
          .page(page)
  end
end
