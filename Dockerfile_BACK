# Multi-stage build for MakeCode Arcade
FROM node:18-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git python3 make g++
RUN npm install -g typescript

# Set working directory
WORKDIR /app

# --- 1. Build makecode-core ---
COPY makecode-core /app/makecode-core
WORKDIR /app/makecode-core

# Install all deps and force gulp to be present
RUN npm install && npm install gulp --save-dev
RUN ./node_modules/.bin/gulp build
RUN npm link

# --- 2. Build makecode-arcade ---
WORKDIR /app
COPY makecode-arcade /app/makecode-arcade
WORKDIR /app/makecode-arcade

ENV PXT_ENV=production
ENV PXT_TARGET=arcade

# Install, link core, and ensure gulp exists here too
RUN npm install && npm install gulp --save-dev
RUN npm link pxt-core

# # Use the absolute path to the binary we just forced in
# WORKDIR /app
# RUN ../makecode-core/node_modules/gulp build ./makecode-arcade

# --- 3. Cleanup ---
# WORKDIR /app/makecode-arcade
# RUN npm prune --production

# --- Runtime Stage ---
FROM node:18-alpine
RUN apk add --no-cache git
WORKDIR /app

# Copy built artifacts and global links
COPY --from=builder /app /app
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN npm install -g typescript

WORKDIR /app/makecode-arcade

ENV NODE_OPTIONS="--max-old-space-size=4096"
ENV PXT_HOSTNAME="0.0.0.0"
ENV PXT_FORCE_LOCAL="1"
ENV PXT_ENV=production
ENV PXT_TARGET=arcade

EXPOSE 3232

# Start server
CMD ["npm", "run", "serve", "--", "--no-browser", "--hostname", "0.0.0.0"]

# Run in the folder that contains both projects
# docker build -f ./makecode-arcade/Dockerfile --tag ctrlaltcode/makecode-arcade:latest .
# docker run -d -p 3232:3232 --name makecode-arcade ctrlaltcode/makecode-arcade:latest
# docker push ctrlaltcode/makecode-arcade:latest
