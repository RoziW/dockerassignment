# Docker Assignment — CI/CD Pipeline

<!-- BUILD_INFO_START -->**Latest build:** `31aad2d` — 2026-07-14 20:31 UTC<!-- BUILD_INFO_END -->

Automated pipeline: `git push main` → GitHub Actions builds a Docker image → publishes to GitHub Container Registry (GHCR) with an immutable SHA tag → this README updates itself with the build info.

## Why this pipeline exists

To eliminate the "it works on my computer" class of bug. Every commit produces one immutable, uniquely-tagged image. Any machine — laptop, server, CI — that pulls `ghcr.io/roziw/dockerassignment:<sha>` gets the exact same bytes running on the exact same Alpine + nginx runtime.

## Pull and run
    docker pull ghcr.io/roziw/dockerassignment:latest
    docker run -p 8080:80 ghcr.io/roziw/dockerassignment:latest

Open http://localhost:8080

## Pipeline breakdown

- **`Dockerfile`** — nginx:alpine base + copy `index.html` into the web root. Alpine chosen for size (~5 MB vs ~80 MB Debian).
- **`.github/workflows/ci.yaml`** — triggers on push to `main`. Runs on a fresh Ubuntu runner (guarantees no local-machine contamination). Logs into GHCR with the auto-provisioned `GITHUB_TOKEN` (short-lived, scoped to this run — safer than a personal access token). Builds and pushes two tags:
  - `:latest` — mutable convenience tag for humans.
  - `:<commit-sha>` — immutable tag for reproducibility. Production should always reference this.
- **README auto-update step** — after a successful build, the workflow rewrites the build-info line above and commits it back. The `[skip ci]` in the commit message prevents an infinite loop of CI-triggering-CI.

## Permissions

- `contents: write` — required to push the README commit back.
- `packages: write` — required to publish the image to GHCR.

Both scoped to this workflow only. Principle of least privilege.