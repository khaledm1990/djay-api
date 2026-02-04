# djay-api

Rails API with an Avo-powered admin interface for managing playlists, tracks, and artists.

## Prerequisites

- Ruby `3.4.5` (see `.ruby-version`)
- PostgreSQL 9.3+ (local dev uses `djay_api_development`)
- `ffmpeg` (required for audio processing)
- Bundler (bundled with Ruby)

## Quick start

```bash
bin/setup
```

`bin/setup` will:
- verify (and install on macOS) `ffmpeg`
- install gems
- prepare the database
- start the server

If you skipped server startup:

```bash
bin/dev
```

The app runs at `http://localhost:3000`.

## Admin dashboard (Avo)

The Avo admin panel is mounted at `/admin`.

## API

- `GET /api/v1/playlists` returns playlists with serialized tracks


  Response Payload

  ```JSON
  {
  "playlists": [
    {
      "id": 1,
      "name": "Late Night Coding",
      "art_work_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6NDUsInB1ciI6ImJsb2JfaWQifX0=--9ddc37a3613a1ac5c842ecf96a2f2049864b6c00/image_6.png",
      "tracks_count_text": "7 Songs",
      "total_duration_text": "1 minute",
      "tracks": [
        {
          "id": 16,
          "title": "Crystal Frequency 600",
          "artist_name": "Neon Harbor",
          "art_work_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MzEsInB1ciI6ImJsb2JfaWQifX0=--812b24b7ae4d4c017b0766ff1ad97e02973b18dc/track_image_8.png",
          "audio_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MzIsInB1ciI6ImJsb2JfaWQifX0=--5198ce9a6c68c1bb99ed4f21329731c024798362/cool-deep-fat-mixed-drums-808_143bpm_F%23_minor.wav",
          "duration": "00:14"
        }
      ]
    },
    {
      "id": 3,
      "name": "Lo Fi Focus",
      "art_work_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6NDcsInB1ciI6ImJsb2JfaWQifX0=--bda15dc4185050fa61488633b8babc55e00d5708/image_4.png",
      "tracks_count_text": "5 Songs",
      "total_duration_text": "1 minute",
      "tracks": [
        {
          "id": 4,
          "title": "Shadow Pulse 571",
          "artist_name": "Solar Echo",
          "art_work_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6NywicHVyIjoiYmxvYl9pZCJ9fQ==--c792a675016e902785378e60b3a7abf1c76058bd/track_image_4.png",
          "audio_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6OCwicHVyIjoiYmxvYl9pZCJ9fQ==--5dfc16282673279123ced70f08ebb75456a36d8d/cool-deep-fat-mixed-drums-808_143bpm_F%23_minor.wav",
          "duration": "00:14"
        },
        {
          "id": 16,
          "title": "Crystal Frequency 600",
          "artist_name": "Neon Harbor",
          "art_work_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MzEsInB1ciI6ImJsb2JfaWQifX0=--812b24b7ae4d4c017b0766ff1ad97e02973b18dc/track_image_8.png",
          "audio_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MzIsInB1ciI6ImJsb2JfaWQifX0=--5198ce9a6c68c1bb99ed4f21329731c024798362/cool-deep-fat-mixed-drums-808_143bpm_F%23_minor.wav",
          "duration": "00:14"
        },
        {
          "id": 22,
          "title": "Golden Horizon 183",
          "artist_name": "Crimson Skyline",
          "art_work_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6NDMsInB1ciI6ImJsb2JfaWQifX0=--f8de92f12c0bd43bbc1b8dd09ee81247e602e24e/track_image_6.png",
          "audio_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6NDQsInB1ciI6ImJsb2JfaWQifX0=--a07f18e84fd864ec5a37b5869e2b36b9b2ff2b21/cool-deep-fat-mixed-drums-808_143bpm_F%23_minor.wav",
          "duration": "00:14"
        }
      ]
    }
  ]


## System architecture and design

- **Web/API layer:** Rails handles routing and request/response orchestration for the JSON API and admin UI.
- **Admin interface:** Avo provides the admin dashboard at `/admin` with resource definitions in `app/avo/resources`.
- **Domain model:** Core entities are `Artist`, `Track`, `Playlist`, and join model `PlaylistTrack`.
- **Media handling:** Audio and artwork are stored via Active Storage; `ffmpeg` is required for audio processing.
- **Data persistence:** PostgreSQL is the primary datastore; see `config/database.yml`.

## Database

Create and migrate:

```bash
bin/rails db:prepare
```

Reset (drops and recreates):

```bash
bin/rails db:reset
```

## Tests

```bash
bundle exec rspec
```

## Local CI

```bash
bin/ci
```

## Media storage

Active Storage is configured for local disk in development/test (see `config/storage.yml`).

