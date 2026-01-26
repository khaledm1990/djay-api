class Track < ApplicationRecord
  belongs_to :artist
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks

  def self.ransackable_attributes(auth_object = nil)
    [ "title" ]
  end

  def cover_url
    "/images/artists/#{artist.name.parameterize}.jpg"
  end

  def duration
    "02:17"
  end
end
