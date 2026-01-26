class Api::V1::PlaylistPresenter < Api::BasePresenter
  def initialize(playlist:)
    @playlist = playlist
  end

  def response
    {
      id: playlist.id,
      name: playlist.name,
      art_work_url: playlist.art_work_url,
      tracks_count_text: tracks_count_text,
      total_duration_text: duration_text(total_duration),
      tracks: tracks_response
    }
  end

  private

  attr_reader :playlist

  def tracks_count_text
    pluralize(tracks_count, "Song")
  end

  def tracks_count
    playlist.tracks.size
  end


  def total_duration
    playlist.total_duration
  end

  def tracks_response
    playlist.tracks.map do |track|
      Api::V1::TrackPresenter.new(track: track).response
    end
  end
end
