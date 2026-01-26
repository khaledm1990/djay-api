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
      duration: track.duration
    }
  end

  private

  attr_reader :track
end
