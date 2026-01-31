require "rails_helper"

RSpec.describe Api::V1::Playlists::ResponsePresenter do
  subject(:response) { described_class.new(playlists: playlists).response }

  let(:artist) { Artist.create!(name: "Daft Punk") }

  let(:first_track) do
    record = Track.new(artist: artist, title: "Around the World")
    attach_image(record, attachment_name: :art_work, filename: "first-track.png")
    record.save!
    allow(record).to receive(:art_work_url).and_return("https://example.com/first-track.png")
    allow(record).to receive(:audio_url).and_return("https://example.com/first-track.mp3")
    allow(record).to receive(:duration).and_return(185)
    record
  end

  let(:second_track) do
    record = Track.new(artist: artist, title: "One More Time")
    attach_image(record, attachment_name: :art_work, filename: "second-track.png")
    record.save!
    allow(record).to receive(:art_work_url).and_return("https://example.com/second-track.png")
    allow(record).to receive(:audio_url).and_return("https://example.com/second-track.mp3")
    allow(record).to receive(:duration).and_return(90)
    record
  end

  let(:first_playlist) do
    record = Playlist.new(name: "Studio Sessions")
    attach_image(record, attachment_name: :art_work, filename: "playlist-one.png")
    record.save!
    record.tracks << [first_track, second_track]
    allow(record).to receive(:art_work_url).and_return("https://example.com/playlist-one.png")
    record
  end

  let(:second_playlist) do
    record = Playlist.new(name: "Late Night")
    attach_image(record, attachment_name: :art_work, filename: "playlist-two.png")
    record.save!
    record.tracks << [first_track]
    allow(record).to receive(:art_work_url).and_return("https://example.com/playlist-two.png")
    record
  end

  let(:playlists) { [first_playlist, second_playlist] }

  it "returns a serialized playlists payload" do
    expect(response).to eq(
      playlists: [
        {
          id: first_playlist.id,
          name: "Studio Sessions",
          art_work_url: "https://example.com/playlist-one.png",
          tracks_count_text: "2 Songs",
          total_duration_text: "5 minutes",
          tracks: [
            {
              id: first_track.id,
              title: "Around the World",
              artist_name: "Daft Punk",
              art_work_url: "https://example.com/first-track.png",
              audio_url: "https://example.com/first-track.mp3",
              duration: "03:05"
            },
            {
              id: second_track.id,
              title: "One More Time",
              artist_name: "Daft Punk",
              art_work_url: "https://example.com/second-track.png",
              audio_url: "https://example.com/second-track.mp3",
              duration: "01:30"
            }
          ]
        },
        {
          id: second_playlist.id,
          name: "Late Night",
          art_work_url: "https://example.com/playlist-two.png",
          tracks_count_text: "1 Song",
          total_duration_text: "3 minutes",
          tracks: [
            {
              id: first_track.id,
              title: "Around the World",
              artist_name: "Daft Punk",
              art_work_url: "https://example.com/first-track.png",
              audio_url: "https://example.com/first-track.mp3",
              duration: "03:05"
            }
          ]
        }
      ]
    )
  end
end
