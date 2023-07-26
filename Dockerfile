# Regular Docker Build without multi-stage
FROM python:3.9-slim

# Set environment variables to prevent writing bytecode and buffering
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install build dependencies (only temporarily needed for the build)
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install required packages
RUN pip install --no-cache-dir flask

# Copy the app source code
COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
