class Api::V1::PlaylistPresenter < Api::BasePresenter
  def initialize(playlist:)
    @playlist = playlist
  end

  def response
    {
      id: playlist.id,
      name: playlist.name,
      cover_url: "/images/playlists/combined.jpg",
      tracks: tracks_response
    }
  end

  private

  attr_reader :playlist

  def tracks_response
    playlist.tracks.map do |track|
      Api::V1::TrackPresenter.new(track: track).response
    end
  end
end
