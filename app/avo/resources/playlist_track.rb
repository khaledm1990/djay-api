class Avo::Resources::PlaylistTrack < Avo::BaseResource
  self.includes = [ :playlist, :track ]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :playlist_id, as: :number
    field :track_id, as: :number
    field :playlist, as: :belongs_to
    field :track, as: :belongs_to
  end
end
