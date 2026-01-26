class Playlist < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
end
