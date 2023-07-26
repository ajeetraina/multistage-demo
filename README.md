# Multistage Build Demo

This repository has been built to demonstrate the power of Multi-Stage Builds.

## Getting Started


### Building the image(Without Multi-Stage Build)

```
docker build -t ajeetraina/test1 .
```



```
  docker build -t ajeetraina/test2-multi . -f Dockerfile.newmultistage
```

```
docker images | grep test2
ajeetraina/test2-multi                                    latest                                                                       97712ca77a9c   22 seconds ago   267MB
```



In this example, we are using Alpine Linux as the base image in the final stage to minimize the image size. The Alpine version of Python images is much smaller compared to their Debian/Ubuntu counterparts.

We've also optimized the installation process by using apt-get to install only the necessary build dependencies in the builder stage and removing them in the final stage to keep the image clean. Additionally, we've removed the unnecessary build-essential package after installing the required Python packages.

These optimizations should help reduce the image size further. Remember that the actual size reduction will depend on the specific requirements and dependencies of your Flask application. By following these practices and carefully selecting a minimal base image, you can achieve a smaller and more efficient Docker image.
