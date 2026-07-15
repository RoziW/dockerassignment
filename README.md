# Docker Assignment — CI/CD Pipeline

## Build History

<!-- BUILD_LOG -->
- `7edcc0a` — Trying rto make my dockerhub also contain all the other folders/files besides the ones in my dockerignore file — 2026-07-15 00:00 UTC
- `e4ff519` — not-so-success — 2026-07-14 23:43 UTC
- `c8db2d9` — success — 2026-07-14 23:40 UTC
- `478d60a` — It didn't work — 2026-07-14 23:32 UTC
- `4f69652` — I'm messing around with the timing of the inputs to be UTC+3 not just UTC — 2026-07-14 23:31 UTC+3
- `21434d8` — ☆*: .｡. o(≧▽≦)o .｡.:*☆ — 2026-07-14 23:28 UTC
- `e2da351` — cosmetic change of the readme file that might cost me all my previous updates hahaha — 2026-07-14 23:27 UTC

- `0124b36` — test rebase workflow — 2026-07-14 22:43 UTC
- `e7301b7` — Merge branch 'main' of https://github.com/RoziW/dockerassignment — 2026-07-14 22:30 UTC
- `f247424` — fix README markers and remove stale GHCR references — 2026-07-14 22:28 UTC
Automated pipeline: `git push main` → GitHub Actions builds a Docker image → publishes to Docker Hub with an immutable SHA tag → this README updates itself with the build info.

## Why this pipeline exists

To eliminate the "it works on my computer" class of bug. Every commit produces one immutable, uniquely-tagged image. Any machine — laptop, server, CI — that pulls `roziw/dockerassignment:<sha>` gets the exact same bytes running on the exact same Alpine + nginx runtime.

## Pull and run
    docker pull <your-dockerhub-username>/dockerassignment:latest
    docker run -p 8080:80 <your-dockerhub-username>/dockerassignment:latest

Open http://localhost:8080

## Pipeline breakdown

- **`Dockerfile`** — nginx:alpine base + copy `index.html` into the web root. Alpine chosen for size (~5 MB vs ~80 MB Debian).
- **`.github/workflows/ci.yaml`** — triggers on push to `main`. Runs on a fresh Ubuntu runner (guarantees no local-machine contamination). Logs into GHCR with the auto-provisioned `DockerHUB token` (short-lived, scoped to this run — safer than a personal access token). Builds and pushes two tags:
  - `:latest` — mutable convenience tag for humans.
  - `:<commit-sha>` — immutable tag for reproducibility. Production should always reference this.
- **README auto-update step** — after a successful build, the workflow rewrites the build-info line above and commits it back. The `[skip ci]` in the commit message prevents an infinite loop of CI-triggering-CI.

## Permissions

- `contents: write` — required to push the README commit back.


Both scoped to this workflow only. Principle of least privilege.