class Api::V1::Playlists::ResponsePresenter < Api::BasePresenter
  def initialize(playlists:)
    @playlists = playlists
  end

  def response
    {
      playlists: playlists_response
    }
  end

  private


  attr_reader :playlists

  def playlists_response
    playlists.map do |playlist|
      Api::V1::PlaylistPresenter.new(playlist: playlist).response
    end
  end
end
