class Track < ApplicationRecord
  belongs_to :artist
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks

  def cover_url
    "/images/artists/#{artist.name.parameterize}.jpg"
  end

  def duration
    "02:17"
  end
end
