class Api::V1::PlaylistsController < ApiController
  def index
    render json: Api::V1::Playlists::ResponsePresenter.new(playlists: Playlist.all).response
  end
end
