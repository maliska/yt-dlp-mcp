FROM node:20-slim

# Install yt-dlp and its runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    yt-dlp \
    python3 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts

# Copy source and build
COPY tsconfig.json ./
COPY src/ ./src/
RUN npm run prepare

RUN mkdir -p /root/Downloads

EXPOSE 3000

ENTRYPOINT ["node", "lib/index.mjs"]
