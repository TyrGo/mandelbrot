# Mandelbrot Explorer API — Dyalog APL

HTTP API for Mandelbrot set visualizations.

## Quick Start

```bash
docker build -t mandelbrot-apl .
docker run --rm -p 8080:8080 mandelbrot-apl

open http://localhost:8080
```

## API Endpoints

### `GET /mandelbrot`

Generate a Mandelbrot visualization.

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `center_x` | float | -0.5 | Real axis center |
| `center_y` | float | 0.0 | Imaginary axis center |
| `zoom` | float | 1.0 | Zoom level |
| `width` | int | 80 | Output columns (max 500) |
| `height` | int | 40 | Output rows (max 500) |
| `max_iter` | int | 100 | Max iterations (max 10000) |
| `format` | string | `ascii` | `ascii` or `json` |

```bash
# ASCII art
curl "http://localhost:8080/mandelbrot?width=80&height=40"

# JSON matrix
curl "http://localhost:8080/mandelbrot?width=10&height=5&format=json"

# Zoom into Seahorse Valley
curl "http://localhost:8080/mandelbrot?center_x=-0.75&center_y=0.1&zoom=50&max_iter=200"
```

### `GET /presets`

Returns preset coordinates for interesting regions.

### `GET /health`

Returns `{"status":"ok"}`.

### `GET /`

Interactive explorer with click-to-zoom.

## Project Structure

```
mandelbrot.dyalog   ⍝ Core computation — complex plane grid + iteration
palette.dyalog      ⍝ Map iteration counts → ASCII characters
presets.dyalog      ⍝ Interesting coordinate presets
server.dyalog       ⍝ HTTP server, routing, query parsing
start.dyalog        ⍝ Entry point
mandelbrot.dyapp    ⍝ Application loader
```

## Development

Mount source directory for live reloading (restart container to pick up changes):

```bash
docker run --rm -p 8080:8080 -v "$(pwd)":/app dyalog/dyalog
```

## How It Works

```apl
⍝ The entire computation is one line — apply a step function max_iter times via ⍣
iters←4⊃{(z c m n)←⍵ ⋄ z←c+(z*2) ⋄ m2←m∧2≥|z ⋄ (m2×z) c m2 (n+m)}⍣max_iter⊢(0×C) C ((⍴C)⍴1) ((⍴C)⍴0)
```