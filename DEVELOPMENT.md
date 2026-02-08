# MakeCode Development Guide

Quick reference for developing makecode-core and makecode-arcade with optimized build times.

## Prerequisites

- Node.js >= 18.0.0
- npm >= 8.0.0
- makecode-core linked to makecode-arcade via `npm link`

## Fast Development Workflow

### Initial Setup (One Time)

```bash
# Build makecode-core (skip webapps for speed)
cd makecode-core
npm install
npm run build:fast

# Link core to arcade
cd ../makecode-arcade
npm link ../makecode-core
npm install
```

### Daily Development

**Terminal 1 - makecode-core (watch mode):**
```bash
cd makecode-core
npm run dev
```
- Watches for file changes
- Auto-rebuilds only what changed (~10-30 seconds)
- Skips webapps for faster builds

**Terminal 2 - makecode-arcade (serve):**
```bash
cd makecode-arcade
pxt link ../makecode-core/
npm run serve
```
- Serves arcade at http://localhost:3232
- Automatically uses latest built files from core

**To see changes:**
1. Edit files in makecode-core or makecode-arcade
2. Wait for rebuild to complete (watch Terminal 1)
3. Refresh browser (F5 or Ctrl+R)

## Environment Variables

- `PXT_ENV=production` - Enables minification (slower builds)
- `NODE_OPTIONS="--max-old-space-size=4096"` - Increases memory limit

## Browser URLs

- Arcade Editor: http://localhost:3232
- Arcade Editor (alternative): http://localhost:3232/index.html

---
