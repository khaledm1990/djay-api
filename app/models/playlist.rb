class Playlist < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks

  has_one_attached :art_work

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
