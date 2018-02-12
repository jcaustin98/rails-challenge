class Expert < ApplicationRecord
  validates :name, presence: true,
            length: { minimum: 2 }

  validates :website, presence: true,
            length: { minimum: 10 }
end
