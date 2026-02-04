class Track < ApplicationRecord
  belongs_to :artist, required: true
  has_many :playlist_tracks, dependent: :destroy, inverse_of: :track
  has_many :playlists, through: :playlist_tracks, inverse_of: :tracks

  has_one_attached :art_work
  has_one_attached :audio_file

  validates :title, presence: true
  validates :art_work, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "title" ]
  end

  def art_work_url
    return nil unless art_work.present?
    Rails.application.routes.url_helpers.rails_representation_url(
      art_work
    )
  end

  def audio_url
    return nil unless audio_file.present?
    Rails.application.routes.url_helpers.rails_blob_url(
      audio_file
    )
  end

  def duration
    return 0.0 unless audio_file.present?
    audio_file.blob.metadata[:duration]
  end
end
