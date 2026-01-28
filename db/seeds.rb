# db/seeds.rb

puts "🌱 Seeding database"

require "set"

PlaylistTrack.delete_all
Track.delete_all
Playlist.delete_all
Artist.delete_all

now = Time.current

# -----------------------------
# Seed media helpers
# -----------------------------
PLAYLIST_IMAGES_DIR = Rails.root.join("db", "data", "images", "playlist")
TRACK_IMAGES_DIR = Rails.root.join("db", "data", "images", "track")
AUDIOS_DIR = Rails.root.join("db", "data", "audios")

playlist_image_paths = Dir.glob(PLAYLIST_IMAGES_DIR.join("**", "*")).select { |p| File.file?(p) }
track_image_paths = Dir.glob(TRACK_IMAGES_DIR.join("**", "*")).select { |p| File.file?(p) }
audio_paths = Dir.glob(AUDIOS_DIR.join("**", "*")).select { |p| File.file?(p) }

if playlist_image_paths.empty?
  puts "⚠️  No images found under #{PLAYLIST_IMAGES_DIR}"
else
  puts "🖼️  Found #{playlist_image_paths.size} image(s)"
end

if audio_paths.empty?
  puts "⚠️  No audios found under #{AUDIOS_DIR}"
else
  puts "🎧 Found #{audio_paths.size} audio file(s)"
end

def attach_file!(record, attachment_name, path)
  filename = File.basename(path)
  record.public_send(attachment_name).attach(
    io: File.open(path, "rb"),
    filename: filename
    # content_type is optional; ActiveStorage can infer it in many setups
  )
end

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
      title: "#{track_titles.sample} #{rand(1000)}",
      artist_id: artist.id,
      created_at: now,
      updated_at: now
    }
  end
end

Track.insert_all!(track_rows)
tracks = Track.order(:id).to_a

# Attach track media (art_work + audio_file)
tracks.each_with_index do |track, idx|
  if track_image_paths.any?
    attach_file!(track, :art_work, track_image_paths[idx % track_image_paths.size])
  end

  if audio_paths.any?
    attach_file!(track, :audio_file, audio_paths[idx % audio_paths.size])

    # If you rely on duration metadata, analysis helps populate it.
    # If your setup uses background jobs, you can switch to analyze_later.
    begin
      track.audio_file.analyze unless track.audio_file.blob.analyzed?
    rescue => e
      puts "⚠️  Audio analyze failed for Track##{track.id} (#{track.title}): #{e.class} - #{e.message}"
    end
  end
end

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

# Attach playlist art_work
playlists.each_with_index do |playlist, idx|
  if playlist_image_paths.any?
    attach_file!(playlist, :art_work, playlist_image_paths.reverse[idx % playlist_image_paths.size])
  end
end

# -----------------------------
# Playlist Tracks (Join Table)
# Guarantee: every playlist has tracks
# -----------------------------
MIN_TRACKS_PER_PLAYLIST = 5

join_rows = []
seen = Set.new

playlists.each do |playlist|
  desired = [ MIN_TRACKS_PER_PLAYLIST, tracks.size ].min
  selected_tracks = tracks.sample(desired)

  extra = rand(0..3)
  if extra > 0 && tracks.size > desired
    selected_tracks += tracks.sample([ extra, tracks.size - desired ].min)
  end
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
puts "Attached artwork to Tracks: #{Track.joins(:art_work_attachment).distinct.count rescue 'n/a'}"
puts "Attached audio to Tracks: #{Track.joins(:audio_file_attachment).distinct.count rescue 'n/a'}"
puts "Attached artwork to Playlists: #{Playlist.joins(:art_work_attachment).distinct.count rescue 'n/a'}"
