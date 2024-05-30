# frozen_string_literal: true

class User < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  def paginated_repositories(page)
    repositories.includes(:checks)
                .order(created_at: :desc)
                .page(page)
  end
end
