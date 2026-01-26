# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "🌱 Seeding database"

PlaylistTrack.delete_all
Track.delete_all
Playlist.delete_all
Artist.delete_all

now = Time.current

# -----------------------------
# Artists
# -----------------------------
artist_names = [
  "Solar Echo",
  "Midnight Static",
  "Velvet Circuit",
  "Neon Harbor",
  "Crimson Skyline"
]

Artist.insert_all!(
  artist_names.map { |name| { name: name, created_at: now, updated_at: now } }
)

artists = Artist.order(:id).to_a

# -----------------------------
# Tracks
# -----------------------------
track_titles = [
  "Starlight Run",
  "Electric Tide",
  "Shadow Pulse",
  "Golden Horizon",
  "Signal Drift",
  "Night Drive",
  "Crystal Frequency",
  "Low Orbit",
  "Afterglow",
  "Moonwire"
]

track_rows = []
artists.each do |artist|
  rand(3..6).times do
    track_rows << {
      name: "#{track_titles.sample} #{rand(1000)}",
      artist_id: artist.id,
      created_at: now,
      updated_at: now
    }
  end
end

Track.insert_all!(track_rows)
tracks = Track.order(:id).to_a


# -----------------------------
# Playlists
# -----------------------------
playlist_names = [
  "Late Night Coding",
  "Road Trip Anthems",
  "Lo Fi Focus",
  "Synthwave Dreams",
  "Morning Energy"
]

Playlist.insert_all!(
  playlist_names.map { |name| { name: name, created_at: now, updated_at: now } }
)

playlists = Playlist.order(:id).to_a

# -----------------------------
# Playlist Tracks (Join Table)
# Guarantee: every playlist has tracks
# -----------------------------
MIN_TRACKS_PER_PLAYLIST = 5

join_rows = []
seen = Set.new

playlists.each do |playlist|
  # Pick at least MIN_TRACKS_PER_PLAYLIST, but never more than total tracks available
  desired = [ MIN_TRACKS_PER_PLAYLIST, tracks.size ].min

  # sample(n) guarantees unique tracks in that selection
  selected_tracks = tracks.sample(desired)

  # Optionally sprinkle a few extra tracks for variety
  extra = rand(0..3)
  selected_tracks += tracks.sample([ extra, tracks.size - desired ].min) if extra > 0 && tracks.size > desired
  selected_tracks.uniq!

  selected_tracks.each do |track|
    key = [ playlist.id, track.id ]
    next if seen.include?(key)

    seen << key
    join_rows << {
      playlist_id: playlist.id,
      track_id: track.id,
      created_at: now,
      updated_at: now
    }
  end
end

PlaylistTrack.insert_all!(join_rows)

puts "✅ Done!"
puts "Artists: #{Artist.count}, Tracks: #{Track.count}, Playlists: #{Playlist.count}, PlaylistTracks: #{PlaylistTrack.count}"
