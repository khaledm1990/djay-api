class Playlist < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy, inverse_of: :playlist

  has_many :tracks, through: :playlist_tracks, inverse_of: :playlists

  has_one_attached :art_work

  validates :name, presence: true
  validates :art_work, presence: true

  scope :with_tracks_and_artists, -> {
    includes(
      tracks: [
        :artist,
        { art_work_attachment: :blob },
        { audio_file_attachment: :blob }
      ],
      art_work_attachment: :blob
    )
    .select(:id, :name)
    .order(:name)
  }

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end

  def art_work_url
    return nil unless art_work.present?
    Rails.application.routes.url_helpers.rails_representation_url(
      art_work
    )
  end

  def total_duration
    tracks.inject(0.0) { |sum, track| sum + track.duration }
  end
end
