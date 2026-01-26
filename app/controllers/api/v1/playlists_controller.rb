class Api::V1::PlaylistsController < ApiController
  before_action :set_playlists, only: [ :index ]
  def index
    render json: Api::V1::Playlists::ResponsePresenter.new(playlists: playlists).response
  end



  private
  attr_reader :playlists

  def set_playlists
    @playlists = Playlist.includes(tracks: :artist).select(:id, :name)
  end
end
