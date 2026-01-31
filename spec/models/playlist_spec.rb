require "rails_helper"

RSpec.describe Playlist, type: :model do
  describe ".with_tracks_and_artists" do
    it "orders by name and preloads tracks, artists, and attachments" do
      artist = Artist.create!(name: "Artist A")

      track = Track.new(title: "Track 1", artist: artist)
      attach_image(track, attachment_name: :art_work)
      attach_audio(track, attachment_name: :audio_file)
      track.save!

      playlist_b = Playlist.new(name: "B Playlist")
      attach_image(playlist_b, attachment_name: :art_work)
      playlist_b.save!
      PlaylistTrack.create!(playlist: playlist_b, track: track)

      playlist_a = Playlist.new(name: "A Playlist")
      attach_image(playlist_a, attachment_name: :art_work)
      playlist_a.save!
      PlaylistTrack.create!(playlist: playlist_a, track: track)

      playlists = described_class.with_tracks_and_artists.to_a

      expect(playlists.map(&:name)).to eq([ "A Playlist", "B Playlist" ])

      playlist = playlists.first
      expect(playlist.association(:tracks)).to be_loaded
      expect(playlist.association(:art_work_attachment)).to be_loaded

      loaded_track = playlist.tracks.first
      expect(loaded_track.association(:artist)).to be_loaded
      expect(loaded_track.association(:art_work_attachment)).to be_loaded
      expect(loaded_track.association(:audio_file_attachment)).to be_loaded
    end

    it "selects only id and name" do
      playlist = Playlist.new(name: "Only Playlist")
      attach_image(playlist, attachment_name: :art_work)
      playlist.save!

      scoped = described_class.with_tracks_and_artists.find(playlist.id)

      expect { scoped.created_at }.to raise_error(ActiveModel::MissingAttributeError)
    end
  end
end
