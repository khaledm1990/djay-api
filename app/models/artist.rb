class Artist < ApplicationRecord
  has_many :tracks, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
end
