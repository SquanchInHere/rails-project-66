# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm do
    state :created, initial: true
    state :requested, :finished, :failed

    event :run_check do
      transitions from: :created, to: :requested
    end

    event :finish do
      transitions from: :requested, to: :finished
    end

    event :fail do
      transitions from: :requested, to: :failed
    end
  end
end
