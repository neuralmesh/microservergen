#!/bin/bash

# Step 4: Create requirements.txt
cat <<EOF > requirements.txt
fastapi
uvicorn[standard]
langchain
pydantic
openai
requests
EOF

# Step 5: Create Dockerfile
cat <<EOF > Dockerfile
FROM python:3.8

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY llmgen.py /app/

CMD ["uvicorn", "llmgen:app", "--host", "0.0.0.0", "--port", "80"]
EOF

# Step 6: Create docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.8'
services:
  llmgen:
    build: .
    ports:
      - "8000:80"
    restart: unless-stopped
EOF

# Step 7: Build and run with Docker Compose
docker compose build
docker compose up -d

