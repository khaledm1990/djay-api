class Avo::Resources::Track < Avo::BaseResource
  self.title = :title
  self.includes = [ :artist, :playlist_tracks, :playlists ]
  # self.attachments = []
  self.search = {
    query: -> { query.ransack(id_eq: q, title_cont: q, m: "or").result(distinct: false) }
  }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :artist, as: :belongs_to
    field :playlist_tracks, as: :has_many
    field :playlists, as: :has_many, through: :playlist_tracks
  end
end
