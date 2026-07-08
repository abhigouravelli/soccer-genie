# syntax=docker/dockerfile:1
FROM python:3.12-slim

WORKDIR /app

# Install dependencies first so this layer is cached across code changes.
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Application source.
COPY . .

EXPOSE 4000

# Production server (no --reload). Host 0.0.0.0 so it's reachable from other
# containers and the host.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "4000"]
