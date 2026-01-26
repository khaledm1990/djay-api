class Avo::Resources::Playlist < Avo::BaseResource
  self.includes = [ :playlist_tracks, :tracks ]
  # self.attachments = []
  self.search = {
    query: -> { query.ransack(id_eq: q, name_cont: q, m: "or").result(distinct: false) }
  }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :playlist_tracks, as: :has_many
    field :tracks, as: :has_many, through: :playlist_tracks
  end
end
