# Multi-stage build for MakeCode Arcade
FROM node:20-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git python3 make g++ bash

# Set working directory
WORKDIR /app

# --- 1. Build makecode-core ---
COPY makecode-core /app/makecode-core
WORKDIR /app/makecode-core

# Install dependencies and build
RUN npm install
RUN npm run build
RUN npm link

# --- 2. Build makecode-arcade ---
WORKDIR /app
COPY makecode-arcade /app/makecode-arcade
WORKDIR /app/makecode-arcade

# Install dependencies and link to core
RUN npm install
RUN npm link pxt-core

# Pre-create necessary directories
RUN mkdir -p built docs/static

# Copy targetconfig to built directory for API access
RUN cp targetconfig.json built/targetconfig.json

# --- Runtime Stage ---
FROM node:20-alpine

# Install runtime dependencies
RUN apk add --no-cache git bash

WORKDIR /app

# Copy built artifacts from builder
COPY --from=builder /app/makecode-core /app/makecode-core
COPY --from=builder /app/makecode-arcade /app/makecode-arcade

# Set up npm links in runtime
WORKDIR /app/makecode-core
RUN npm link

WORKDIR /app/makecode-arcade
RUN npm link pxt-core

# Environment variables
ENV NODE_OPTIONS="--max-old-space-size=4096"
ENV PXT_HOSTNAME="localhost"
ENV PXT_FORCE_LOCAL="1"
ENV PXT_ENV="production"
ENV PXT_TARGET="arcade"

EXPOSE 3232

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3232/ || exit 1

# Start server
CMD ["npm", "run", "serve", "--", "--no-browser", "--hostname", "0.0.0.0"]

# Build and run instructions:
# docker build -f ./makecode-arcade/Dockerfile --tag ctrlaltcode/makecode-arcade:latest .
# docker run -d -p 3232:3232 --name makecode-arcade ctrlaltcode/makecode-arcade:latest
# docker push ctrlaltcode/makecode-arcade:latest
