# Changelog

## 2026-11-16: Deploy on Railway button

- README: added the Deploy on Railway button for the published template `postiz-2`. No change to the images or the services.

## 2026-11-16: Postiz v2.26.0, Temporal 1.32.2

First release of the template.

- Postiz `ghcr.io/gitroomhq/postiz-app:v2.26.0@sha256:875e61ac5d0ac43c3dec78a78a7032dfb03d9a8c6d4936ebb18adb606cc207c5`
- Temporal `temporalio/server:1.32.2@sha256:7bf69188a6232fea14869b9cef3d94aa82a1601d99517f7e86c71f22da4e0670` with the schema tool from `temporalio/admin-tools:1.32.2@sha256:4a95866efba29d7e17ab012df5232795e8b0ad0f7d5f9d1ec4df321f7792a754`
- Login cookie is host-only (not `.railway.app`), and registration closes after the first account.
