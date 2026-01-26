class Api::V1::TrackPresenter < Api::BasePresenter
  def initialize(track:)
    @track = track
  end

  def response
    {
      id: track.id,
      title: track.title,
      artist_name: track.artist.name,
      art_work_url: track.art_work_url,
      duration: formatted_duration
    }
  end

  private

  attr_reader :track

def formatted_duration
  total = track.duration.to_i
  minutes = total / 60
  seconds = total % 60

  format("%02d:%02d", minutes, seconds)
end
end
