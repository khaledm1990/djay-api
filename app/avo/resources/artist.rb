class Avo::Resources::Artist < Avo::BaseResource
  self.includes = [ :tracks ]
  # self.attachments = []
  self.search = {
    query: -> { query.ransack(id_eq: q, name_cont: q, m: "or").result(distinct: false) }
  }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :tracks, as: :has_many
  end
end
