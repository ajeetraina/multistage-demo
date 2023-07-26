# Multistage Build Demo

This repository has been built to demonstrate the power of Multi-Stage Builds.

## Getting Started


### Building the image(Without Multi-Stage Build)

- 1. We will use the default Dockerfile. This first sets the base image for our Docker container.
- 2. We're using the official Python 3.9 slim image as our starting point.
- 3. The slim version of the Python image is smaller than the regular version as it contains only essential components.
- 4. These environment variables are set to instruct Python to not write bytecode files and to run the application with unbuffered output. These settings help avoid potential issues and ensure consistency in the containerized environment.
- 5. This part of the Dockerfile installs build dependencies using the apt-get package manager. We are installing build-essential, which includes essential tools like gcc and make, temporarily to build some Python packages that might require compilation. After installing the dependencies, we immediately clean the package cache to reduce image size.
- 6. The WORKDIR instruction sets the working directory for subsequent commands in the Dockerfile. We set it to /app so that our application files will be copied and executed from this directory
- 7. We use pip to install the required Python package, Flask, which is a micro web framework used for building web applications in Python. The --no-cache-dir option ensures that pip does not create a local cache of downloaded package files, saving space in the image.
- 8. The EXPOSE instruction informs Docker that the container will listen on port 5000 at runtime. However, this does not actually publish the port on the host machine. It is just a documentation step, and you'll still need to publish the port explicitly when running the container using the -p option.
 

Let's build:

```
docker build -t ajeetraina/test1 . -f Dockerfile
```

## Results:

```
 docker images | grep test1
ajeetraina/test1                                     latest                                                                       9cf11ff033f8   7 seconds ago    611MB
```


## Using Multi-Stage Builds

- In this stage, we start with the Python 3.9-alpine image as the base.
- The alpine image is significantly smaller compared to other Python images, making it a good choice for reducing the image size.
- PYTHONDONTWRITEBYTECODE and PYTHONUNBUFFERED environment variables are set to 1, which prevents Python from writing bytecode files and forces it to print directly to the console, respectively.
- These settings help in optimizing the Python runtime behavior for use in containers.
- Here, we use apk, the package manager for Alpine Linux, to install build-base. This package includes essential build tools like gcc, libc-dev, and make, which are needed for building certain Python packages that may require compilation.
- The WORKDIR instruction sets the working directory for subsequent commands to /app. This is where we will copy our application files.
- Here, we copy the requirements.txt file into the /app directory and then install the Python dependencies using pip. By copying the requirements.txt file first, we leverage Docker's build cache. If the requirements.txt file has not changed, Docker will reuse the cached layer, saving time during subsequent builds.
- We copy the main application file, app.py, into the /app directory.
- In this stage, we start with the Python 3.9-alpine image again as the base. This ensures that our final image is also small and optimized.
- Here, we use apk again to install libpq, a runtime dependency required to connect to PostgreSQL databases.
- Similar to the first stage, we set the working directory to /app for the final stage.
- In this step, we use the --from=builder flag to copy only the necessary files from the builder stage to the final stage. Specifically, we copy the Python packages installed in /root/.local and the app.py file from the /app directory of the builder stage. This way, we avoid bringing unnecessary build artifacts and dependencies into the final image, resulting in a more lightweight and efficient container.
- The EXPOSE instruction documents that the container will listen on port 5000 at runtime. However, you still need to publish this port explicitly when running the container using the -p option.
  

```
# Stage 1: Build the app
FROM python:3.9-alpine as builder

# Set environment variables to prevent writing bytecode and buffering
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install build dependencies (only temporarily needed for the build)
RUN apk add --no-cache build-base

WORKDIR /app

# Copy requirements first to leverage Docker caching
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Copy the rest of the app source code
COPY app.py .

# Stage 2: Create a lightweight image
FROM python:3.9-alpine as final

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH "$PATH:/root/.local/bin"

# Install runtime dependencies (only what's necessary to run the app)
RUN apk add --no-cache libpq

WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app/app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

Let's build this new Docker Image


```
docker build -t ajeetraina/multistage1 . -f Dockerfile.newmultistage
```


## Results:

```
docker images | grep multistage1
ajeetraina/multistage1                                    latest                                                                       fc04ecabfa4e   7 seconds ago    267MB
```

You can see the size difference and optimisation.

