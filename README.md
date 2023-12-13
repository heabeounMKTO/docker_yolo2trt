## PyTorch .pt to TensorRT .trt Engine Conversion tool

## Prerequisites

if you dont already have it , please install the following:
- `Nvidia Drivers` 
- `docker` 
- `nvidia-docker`
- `make` *(likely installed already if you are on linux)*<br>
<sup>*instructions for installing the components above are out of the scope of this readme*</sup>

## Overview
this tool is glued together, so for ease of use and ease of mind , it is recommended (the way *heabeoun*™ intended) is to run it in a docker container. currently , you can build and run the container by running.

### Conversion 

build and store the base image for conversion in a local docker registry, it will take awhile 

start a local docker registry, on port 5000, for example.
```bash
docker run -d -p 5000:5000 --name registry registry:latest
```
then, build base image 

```bash
sudo make trtconvbase
```
and then the conversion

```bash
sudo make trt_engine $MODEL_DIR=/path/to/model/folder $MODEL_NAME=/path/to/model/file
```

`make` arguments

| Argument | Type | Description |
|----------|------|-------------|
| DOCKER_REGISTRY | Optional | address of the (local) docker registry that you build and store your images to should you have a different port than the default 5000|
| TRT_CONVBASE | Optional | name of TRT conversion container |
| MODEL_DIR | Required | directory that stores the .pt models, will be mounted to docker container |
| MODEL_NAME | Required | name of the model you want converted |
