# Game Haven - Standalone Deployment
# Optimized multi-stage build for self-hosting

# ===================
# Stage 1: Build
# ===================
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source
COPY . .

# Build the application
RUN npm run build

# ===================
# Stage 2: Production
# ===================
FROM nginx:alpine

# Install envsubst for runtime config
RUN apk add --no-cache bash

# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx config
COPY deploy/standalone/nginx.conf /etc/nginx/conf.d/default.conf

# Copy startup script
COPY deploy/standalone/start.sh /docker-entrypoint.d/40-runtime-config.sh
RUN chmod +x /docker-entrypoint.d/40-runtime-config.sh

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:80/health || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
