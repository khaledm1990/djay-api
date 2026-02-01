require "rails_helper"

RSpec.describe "GET /api/v1/playlists", type: :request do
  let(:artist) { Artist.create!(name: "Daft Punk") }

  let(:track_one) do
    record = Track.new(artist: artist, title: "Around the World")
    attach_image(record, attachment_name: :art_work, filename: "track-one.png")
    attach_audio(record, attachment_name: :audio_file, filename: "track-one.mp3")
    record.save!
    record.audio_file.blob.update!(metadata: { duration: 185 })
    record
  end

  let(:track_two) do
    record = Track.new(artist: artist, title: "One More Time")
    attach_image(record, attachment_name: :art_work, filename: "track-two.png")
    attach_audio(record, attachment_name: :audio_file, filename: "track-two.mp3")
    record.save!
    record.audio_file.blob.update!(metadata: { duration: 90 })
    record
  end

  let!(:late_night) do
    record = Playlist.new(name: "Late Night")
    attach_image(record, attachment_name: :art_work, filename: "late-night.png")
    record.save!
    record.tracks << track_one
    record
  end

  let!(:studio_sessions) do
    record = Playlist.new(name: "Studio Sessions")
    attach_image(record, attachment_name: :art_work, filename: "studio-sessions.png")
    record.save!
    record.tracks << [ track_one, track_two ]
    record
  end

  it "returns playlists with serialized tracks" do
    get "/api/v1/playlists"

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body, symbolize_names: true)

    expect(body[:playlists].map { |playlist| playlist[:name] }).to eq(
      [ "Late Night", "Studio Sessions" ]
    )

    late_night_payload = body[:playlists].first
    expect(late_night_payload).to include(
      name: "Late Night",
      tracks_count_text: "1 Song",
      total_duration_text: "3 minutes"
    )

    expect(late_night_payload[:art_work_url]).to match(%r{\Ahttp://localhost:3000})
    expect(late_night_payload[:tracks]).to contain_exactly(
      include(
        title: "Around the World",
        artist_name: "Daft Punk",
        duration: "03:05"
      )
    )

    studio_sessions_payload = body[:playlists].last
    expect(studio_sessions_payload).to include(
      name: "Studio Sessions",
      tracks_count_text: "2 Songs",
      total_duration_text: "5 minutes"
    )
    expect(studio_sessions_payload[:art_work_url]).to match(%r{\Ahttp://localhost:3000})
    expect(studio_sessions_payload[:tracks]).to contain_exactly(
      include(
        title: "Around the World",
        artist_name: "Daft Punk",
        duration: "03:05"
      ),
      include(
        title: "One More Time",
        artist_name: "Daft Punk",
        duration: "01:30"
      )
    )
  end
end
