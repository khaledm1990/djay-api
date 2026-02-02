require "rails_helper"

RSpec.describe Api::V1::PlaylistPresenter do
  subject(:response) { described_class.new(playlist: playlist).response }

  let(:artist) { Artist.create!(name: "Daft Punk") }
  let(:track_one) do
    record = Track.new(artist: artist, title: "Around the World")
    attach_image(record, attachment_name: :art_work, filename: "one.png")
    record.save!
    allow(record).to receive(:art_work_url).and_return("https://example.com/one.png")
    allow(record).to receive(:audio_url).and_return("https://example.com/one.mp3")
    allow(record).to receive(:duration).and_return(185)
    record
  end
  let(:track_two) do
    record = Track.new(artist: artist, title: "One More Time")
    attach_image(record, attachment_name: :art_work, filename: "two.png")
    record.save!
    allow(record).to receive(:art_work_url).and_return("https://example.com/two.png")
    allow(record).to receive(:audio_url).and_return("https://example.com/two.mp3")
    allow(record).to receive(:duration).and_return(90)
    record
  end
  let(:playlist) do
    record = Playlist.new(name: "Studio Sessions")
    attach_image(record, attachment_name: :art_work, filename: "playlist.png")
    record.save!
    record.tracks << [ track_one, track_two ]
    allow(record).to receive(:art_work_url).and_return("https://example.com/playlist.png")
    record
  end

  it "returns a serialized playlist payload" do
    expect(response).to eq(
      id: playlist.id,
      name: "Studio Sessions",
      art_work_url: "https://example.com/playlist.png",
      tracks_count_text: "2 Songs",
      total_duration_text: "5 minutes",
      tracks: [
        {
          id: track_one.id,
          title: "Around the World",
          artist_name: "Daft Punk",
          art_work_url: "https://example.com/one.png",
          audio_url: "https://example.com/one.mp3",
          duration: "03:05"
        },
        {
          id: track_two.id,
          title: "One More Time",
          artist_name: "Daft Punk",
          art_work_url: "https://example.com/two.png",
          audio_url: "https://example.com/two.mp3",
          duration: "01:30"
        }
      ]
    )
  end
end
