#!/bin/bash

# Step 1: Fork and clone the neuralmesh/apimesh repository using GitHub CLI
gh repo fork neuralmesh/apimesh --org neuralmesh --fork-name=microservergen --clone --remote
gh repo clone neuralmesh/microservergen
cd microservergen
gh repo set-default neuralmesh/microservergen

# Step 2: Use gitraw-server API to fetch the gitraw-server.sh script
curl http://localhost:8000/neuralmesh/textraw-server/main/gitraw-server.sh > gitraw-server.sh

# Step 3: Copy the modified server.py code
cat <<EOF > microservergen.py
from fastapi import FastAPI
from fastapi.responses import PlainTextResponse

app = FastAPI()

@app.get("/{owner}/{repo}/{issue_number}", response_class=PlainTextResponse)
async def read_issue(owner: str, repo: str, issue_number: int):
    return f"Owner: {owner}, Repository: {repo}, Issue Number: {issue_number}"
EOF

# Step 4: Create requirements.txt
cat <<EOF > requirements.txt
fastapi
uvicorn[standard]
requests
EOF

# Step 5: Create Dockerfile
cat <<EOF > Dockerfile
FROM python:3.8

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY microservergen.py /app/

CMD ["uvicorn", "microservergen:app", "--host", "0.0.0.0", "--port", "80"]
EOF

# Step 6: Create docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.8'
services:
  microservergen:
    build: .
    ports:
      - "8000:80"
    restart: unless-stopped
EOF

# Step 7: Build and run with Docker Compose
docker compose build
docker compose up -d

