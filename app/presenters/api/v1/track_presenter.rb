class Api::V1::TrackPresenter < Api::BasePresenter
  def initialize(track:)
    @track = track
  end

  def response
    {
      id: track.id,
      title: track.title,
      artist_name: track.artist.name,
      cover_url: track.cover_url,
      duration: track.duration
    }
  end

  private

  attr_reader :track
end
