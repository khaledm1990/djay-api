class Artist < ApplicationRecord
  has_many :tracks, dependent: :destroy

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
end
