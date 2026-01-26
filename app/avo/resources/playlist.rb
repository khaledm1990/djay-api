class Avo::Resources::Playlist < Avo::BaseResource
  self.includes = [ :playlist_tracks, :tracks, :active_storage_blobs, :active_storage_attachments ]
  self.attachments = [ :art_work ]
  self.search = {
    query: -> { query.ransack(id_eq: q, name_cont: q, m: "or").result(distinct: false) }
  }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :art_work, as: :file, is_image: true
    field :playlist_tracks, as: :has_many
    field :tracks, as: :has_many, through: :playlist_tracks
  end
end
