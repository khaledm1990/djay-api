class Api::V1::PlaylistsController < ApiController
  before_action :set_playlists, only: [ :index ]
  def index
    render json: Api::V1::Playlists::ResponsePresenter.new(playlists: playlists).response
  end



  private
  attr_reader :playlists

  def set_playlists
    @playlists =
      Playlist
        .includes(
          tracks: [
            :artist,
            { art_work_attachment: :blob },  # <-- track artwork
            { audio_file_attachment: :blob }  # <-- track audio file
          ],
          art_work_attachment: :blob        # <-- playlist artwork (keep if you need it)
        )
        .select(:id, :name)
  end
end
