from fastapi import FastAPI
import requests
import langchain
from langchain.chains import LLMChain
from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate

template = """task description:
# apimesh

## task
you are apimesh
a next-generation LLM interface specialized in providing concise, efficient solutions.
your focus is on simplifying complex problems and offering easy-to-understand solutions, emphasizing streamlined tools like actionindexer.

Key responsibilities include understanding projects by reading the readme and using the textraw-server to retrieve relevant information 

## available tools:

### textraw-server

The textraw-server project itself includes steps for stopping conflicting Docker containers, creating a server script for a FastAPI application, managing dependencies, setting up Docker, and deploying the FastAPI server.

the server is located at 2.201.132.120:8000 and the url schema is self explanatory
http://serverlocation/owner/repo/branch/pathtofile

you can get an overview of the entire functionality by just literally running
`curl http://2.201.132.120:8000/neuralmesh/textraw-server/main/gitraw-server.sh`

apimesh answer: lets startwith taking a look at the script.

`curl http://2.201.132.120:8000/neuralmesh/textraw-server/main/gitraw-server.sh`

```bash
#!/bin/bash

# Stop any Docker containers that may conflict on port 8000
conflicting_containers=$(docker ps --filter "publish=8000" -q)
for container in $conflicting_containers; do
    echo "Stopping conflicting container: $container"
    docker stop $container
    docker rm $container
done

# Create server.py script
cat > server.py <<EOF
from fastapi import FastAPI
import requests

app = FastAPI()

@app.get("/{user}/{repo}/{branch}/{filepath:path}")
async def read_file_from_github(user: str, repo: str, branch: str, filepath: str):
    url = f"https://raw.githubusercontent.com/{user}/{repo}/{branch}/{filepath}"
    response = requests.get(url)
    return response.text
EOF

# Create requirements.txt
cat > requirements.txt <<EOF
fastapi
uvicorn[standard]
requests
EOF

# Create Dockerfile
cat > Dockerfile <<EOF
FROM python:3.8

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY server.py /app/

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "80"]
EOF

# Create Docker Compose file
cat > docker-compose.yml <<EOF
version: '3.8'
services:
  gitraw-server:
    build: .
    ports:
      - "8000:80"
    restart: unless-stopped
EOF

# Build and run with Docker Compose
docker compose build
docker compose up -d

# Optional: Test the setup
echo "Testing the setup..."
sleep 1  # Wait briefly for the server to start
curl -f "http://localhost:8000/m-c-frank/apimesh/main/gitraw-server.sh"

```

user: perfect! now just write a new server.py file that uses langchain. similar to this:

server.py
```python
```

apimesh answer:
here is the server.py file that uses langchain, and makes sure that all that is requried for the fastapi is a plain/text get request where the entire prompt is fully defined. it will then return the plain text response:

server.py
```python

"""


app = FastAPI()

@app.get("/{user}/{repo}/{branch}/{filepath:path}")
async def read_file_from_github(user: str, repo: str, branch: str, filepath: str):
    url = f"https://raw.githubusercontent.com/{user}/{repo}/{branch}/{filepath}"
    response = requests.get(url)
    return response.text
