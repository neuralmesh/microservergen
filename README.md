# microservergen
This script, microservergen.sh, automates the creation of a microserver that simulates the functionality described in a textdump.

## Overview
The script sets up a FastAPI server inside a Docker container. It's configured to respond with specific implementation details of an issue text dump when accessed via a web URL.
for now this will be based on github issues and is using the gh cli to get the entire disccussion history of a particular issue to propose a way to implement it.

## relevant tools
it also has an understanding of relevant tools for this task. one of which is gitraw-server. where if requried, the server can make a request to and fetch the raw content of a file hosted on github. here is the actual readme textdump of that project:

```bash
using the textraw-server to retrieve relevant information (http://2.201.132.120:8000/{user}/{repo}/{branch}/{filepath}). The textraw-server is completely described by the provided script, which includes steps for stopping conflicting Docker containers, creating a server script for a FastAPI application, managing dependencies, setting up Docker, and deploying the FastAPI server. My approach is to offer clear, actionable advice based on the user's query, ensuring the solutions are straightforward and tailored to specific needs.
```

## Key Features
Docker Container Management: Stops any conflicting Docker containers using port 8000.
FastAPI Server: Creates a Python FastAPI server script to handle HTTP GET requests.
Docker and Docker Compose Setup: Includes Dockerfile and docker-compose.yml for containerization and orchestration.
Automatic Build and Deployment: Builds and deploys the Docker container, making the server accessible on localhost:8000.
## How to Use
Run ./microservergen.sh.
Access the server at http://localhost:8000/{owner}/{repo}/{issue_number}.
Prerequisites
Docker and Docker Compose should be installed on your machine.
## Testing
The script includes an optional curl command for testing: curl -f "http://localhost:8000/m-c-frank/apimesh/main/gitraw-server.sh".
