# gettoarun/mule

A Simplified Mule CE Container Base Image.


While, the image can be used for raw consumption, this image 
was designed to be used as a base image. 

So customize $MH/apps and $MH/domains as needed.


## Best practice 
  - RUN chown to mule user precreated here.

## Usage:

To build a custom base image version

`sh docker build --build-arg muleversion=3.9.0`


To use as a base image in your Dockerfile

` FROM gettoarun/mule:3.9.0
   ...`

## Todo

* Need to automate in codeship for all release version
