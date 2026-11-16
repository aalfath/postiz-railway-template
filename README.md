# Postiz on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/postiz-2?utm_medium=integration&utm_source=button&utm_campaign=postiz)

Railway template for [Postiz](https://github.com/gitroomhq/postiz-app), the open-source social media scheduler. Every app service builds from this repo, so a merge to `main` here shows up as an "update available" notice in the projects of everyone who deployed the template. Each deployer chooses when to apply it.

## What it deploys

| Service | Source | Notes |
|---|---|---|
| **Postiz** | `postiz/` in this repo, `ghcr.io/gitroomhq/postiz-app:v2.26.0` pinned by digest | Web app, API and the Temporal worker behind nginx on port 5000. Media on a volume at `/uploads`. Public domain. |
| **Temporal** | `temporal/` in this repo, `temporalio/server:1.32.2` plus the schema tool from `temporalio/admin-tools:1.32.2`, both pinned by digest | Runs the post schedule. Creates and migrates its two databases on every start, then registers the `default` namespace. Private network only. |
| **Postgres** | Railway Postgres | Postiz's database plus Temporal's `temporal` and `temporal_visibility` databases. |
| **Redis** | Railway Redis | Cache and queues. |

There is no Elasticsearch: Temporal uses Postgres for visibility, which supports the search attributes Postiz registers.

### Changes from the upstream image

- **Host-only login cookie.** Postiz sets its `auth` cookie on the registrable domain of `FRONTEND_URL`. For a `*.up.railway.app` address that is `.railway.app`, so browsers would send the session to every app hosted on Railway. nginx rewrites the cookie's domain to the exact host you opened.
- **Port handling.** nginx listens on Railway's `PORT` (5000). The backend also reads `PORT`, so the start script gives it 3000.
- Fixed settings from upstream's docker-compose are baked into the image: `IS_GENERAL`, `BACKEND_INTERNAL_URL`, `STORAGE_PROVIDER=local`, `UPLOAD_DIRECTORY`, `RUN_CRON`.

## Variables

Set by the template. You don't need to enter anything at deploy time.

| Service | Variable | Value |
|---|---|---|
| Postiz | `MAIN_URL`, `FRONTEND_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` |
| Postiz | `NEXT_PUBLIC_BACKEND_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}/api` |
| Postiz | `JWT_SECRET` | generated secret |
| Postiz | `DATABASE_URL`, `REDIS_URL`, `TEMPORAL_ADDRESS` | references to the other services |
| Postiz | `DISABLE_REGISTRATION` | `true`: the first sign-up creates the instance, everyone after that needs an invite |
| Postiz | `PORT` | `5000` |
| Temporal | `POSTGRES_SEEDS`, `POSTGRES_USER`, `POSTGRES_PWD` | references to Postgres |
| Temporal | `PORT` | `7243` (Temporal's HTTP API, used for the health check) |

Optional, add them to the Postiz service yourself: social network keys (`X_API_KEY`, `LINKEDIN_CLIENT_ID`, …, see the [provider docs](https://docs.postiz.com/providers)), `OPENAI_API_KEY`, and email (`EMAIL_PROVIDER=resend`, `RESEND_API_KEY`, `EMAIL_FROM_ADDRESS`, `EMAIL_FROM_NAME`). For a custom domain, point `MAIN_URL`, `FRONTEND_URL` and `NEXT_PUBLIC_BACKEND_URL` (with `/api`) at it.

## Updates

New Postiz or Temporal releases land here as a pull request that bumps the pinned tag and digest and adds a `CHANGELOG.md` entry. Each one is tested on a scratch Railway project before it's merged. Read the changelog before you apply an update in your project. Postiz runs its database migrations on start, and Temporal migrates its schema on start.

Upstream: [Postiz](https://github.com/gitroomhq/postiz-app) (AGPL-3.0), [Postiz docs](https://docs.postiz.com/), [Temporal](https://github.com/temporalio/temporal).
