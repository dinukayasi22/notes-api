# Notes API

A simple REST API for managing notes, built with Node.js, Express, and Supabase.

## Overview

This project provides CRUD endpoints for notes:

- List all notes
- Get a note by ID
- Create a note
- Update a note
- Delete a note
- Health check endpoint for monitoring

The API stores data in a Supabase Postgres table and includes Docker support for deployment.

## Tech Stack

- Node.js
- Express
- Supabase JavaScript client (`@supabase/supabase-js`)
- Docker + Docker Compose
- Bash utility scripts (server setup, deployment, health checks)

## Project Structure

```text
notes-api/
|- index.js                  # App entrypoint, middleware, routes, health check
|- routes/
|  \- notes.js               # Notes CRUD endpoints
|- db/
|  \- supabase.js            # Supabase client setup
|- schema.sql                # SQL schema, trigger, RLS policy, seed data
|- Dockerfile                # Container build file
|- docker-compose.yml        # Compose service definition
|- scripts/
|  |- setup.sh               # Ubuntu server bootstrap (Docker + Compose)
|  |- deploy.sh              # Pull latest code and redeploy containers
|  \- healthcheck.sh         # API/container health check utility
|- package.json
\- .env                      # Environment variables (local)
```

## API Base URL

Local default:

- `http://localhost:5000`

Main route prefix:

- `http://localhost:5000/api/notes`

Health endpoint:

- `http://localhost:5000/api/health`

## Environment Variables

Create a `.env` file in the project root:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_KEY=your_supabase_key
CORS_ORIGIN=*
PORT=5000
```

### Required

- `SUPABASE_URL`
- `SUPABASE_KEY`

If either required variable is missing, the app exits during startup.

## Database Setup (Supabase)

Run `schema.sql` in your Supabase SQL editor to create:

- `notes` table
- `updated_at` trigger function + trigger
- Row Level Security enabled
- Open policy (`Allow all access`)
- Seed rows

## Run Locally (Without Docker)

### 1) Install dependencies

```bash
npm install
```

### 2) Start in development mode

```bash
npm run dev
```

### 3) Or start normally

```bash
npm start
```

## Run with Docker

### Build and run

```bash
docker compose up --build -d
```

### Stop

```bash
docker compose down
```

The container exposes port `5000` and includes a Docker health check to `/api/health`.

## API Endpoints

### 1) Get all notes

- Method: `GET`
- URL: `/api/notes`
- Response: `200 OK` with array of notes (newest first)

### 2) Get note by ID

- Method: `GET`
- URL: `/api/notes/:id`
- Response: `200 OK` with note object

### 3) Create note

- Method: `POST`
- URL: `/api/notes`
- Body:

```json
{
  "title": "My Note",
  "content": "Optional note content"
}
```

- Validation: `title` is required
- Response: `201 Created` with inserted note

### 4) Update note

- Method: `PUT`
- URL: `/api/notes/:id`
- Body:

```json
{
  "title": "Updated title",
  "content": "Updated content"
}
```

- Response: `200 OK` with updated note

### 5) Delete note

- Method: `DELETE`
- URL: `/api/notes/:id`
- Response: `200 OK` with success message

### 6) Health check

- Method: `GET`
- URL: `/api/health`
- Response:

```json
{
  "status": "ok",
  "timestamp": "2026-04-13T00:00:00.000Z"
}
```

## Example cURL Commands

```bash
# Health
curl http://localhost:5000/api/health

# Get all notes
curl http://localhost:5000/api/notes

# Create note
curl -X POST http://localhost:5000/api/notes \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn Docker","content":"Use docker compose for local runs"}'

# Get one note
curl http://localhost:5000/api/notes/<note-id>

# Update note
curl -X PUT http://localhost:5000/api/notes/<note-id> \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated","content":"Updated content"}'

# Delete note
curl -X DELETE http://localhost:5000/api/notes/<note-id>
```

## Deployment Scripts (`scripts/`)

### `setup.sh`

Bootstraps a fresh Ubuntu server:

- Updates packages
- Installs Docker + Docker Compose plugin
- Adds `ubuntu` user to docker group
- Enables Docker service on startup

Run as root:

```bash
sudo bash scripts/setup.sh
```

### `deploy.sh`

Deploy flow:

- Clone or pull latest repo in `/home/ubuntu/notes-api`
- Ensure `.env` exists
- `docker compose down`
- `docker compose up --build -d`
- Prune unused images

Run:

```bash
bash scripts/deploy.sh
```

Before first use, update `REPO_URL` in `scripts/deploy.sh`.

### `healthcheck.sh`

Checks `/api/health` with retries and prints diagnostics (container status, memory, disk, logs).

Run:

```bash
bash scripts/healthcheck.sh
```

## Current Notes / Caveats

- No authentication is implemented.
- Current RLS policy in `schema.sql` allows all operations.
- CORS defaults to `*` unless overridden.
- No automated tests are currently configured.

## Recommended Next Improvements

- Add auth (JWT or Supabase Auth)
- Tighten Supabase RLS policies
- Add request validation (e.g., Joi/Zod)
- Add centralized error handling
- Add tests (unit + integration) and CI pipeline
- Add pagination/filtering for `GET /api/notes`

## License

No license file is currently included. Add one (for example MIT) if needed.
