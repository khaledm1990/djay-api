require "rails_helper"

RSpec.describe Api::V1::TrackPresenter do
  subject(:response) { described_class.new(track: track).response }

  let(:artist) { Artist.create!(name: "Daft Punk") }
  let(:duration) { 185 }
  let(:track) do
    record = Track.new(artist: artist, title: "Around the World")
    attach_image(record, attachment_name: :art_work)
    record.save!
    allow(record).to receive(:art_work_url).and_return("https://example.com/art.png")
    allow(record).to receive(:audio_url).and_return("https://example.com/audio.mp3")
    allow(record).to receive(:duration).and_return(duration)
    record
  end

  it "returns a serialized track payload" do
    expect(response).to eq(
      id: track.id,
      title: "Around the World",
      artist_name: "Daft Punk",
      art_work_url: "https://example.com/art.png",
      audio_url: "https://example.com/audio.mp3",
      duration: "03:05"
    )
  end

  context "when duration is nil" do
    let(:duration) { nil }

    it "formats duration as 00:00" do
      expect(response[:duration]).to eq("00:00")
    end
  end
end
