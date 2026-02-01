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
- There is currently **no API authentication/authorization** layer in this app

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

## Media storage

Active Storage is configured for local disk in development/test (see `config/storage.yml`).
