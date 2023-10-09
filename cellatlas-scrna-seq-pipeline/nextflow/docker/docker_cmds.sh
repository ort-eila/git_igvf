#!/bin/bash

docker build -t eilalan/cellatlas_env .

# test the images
docker run -it eilalan/cellatlas_env bash

# Tag the image
# docker tag eilalan/cellatlas_env <registry_username>/<image_name>:<tag>

# Push the image
docker push eilalan/cellatlas_env:latest
