# A Simplified Mule CE Container Base Image.
# 
# While, the image can be used for raw consumption, this image 
# was designed to be used as a base image. 
# 
# So customize $MH/apps and $MH/domains as needed.
# 
# Best practice 
#   - RUN chown to mule user precreated here.
#
#
# Usage:
#
#  To build a custom version
#
#   docker build --build-arg muleversion=3.9.0
#

FROM java:8-jdk-alpine

MAINTAINER Arun N Kumar <gettoarun@gmail.com>

ARG muleversion 

ENV MULE_HOME=/opt/mule
ENV MULE_VERSION=${muleversion}
ENV MULE_MD5=5ca7d9bba92c0b50ceef1daaf3bc7640
ENV TZ=America/New_York

# Upgrade alpine for latest patches and cache refresh.
RUN apk --no-cache update && apk --no-cache upgrade && \
    apk --no-cache add ca-certificates && update-ca-certificates && apk --no-cache add openssl && \
    apk add --update tzdata && rm -rf /var/cache/apk/* && \
    echo ${TZ} > /etc/timezone

# Create an application user
RUN adduser -D -g "" mule mule

# Prep for download
RUN mkdir /opt/mule-standalone-${MULE_VERSION} && \
    ln -s /opt/mule-standalone-${MULE_VERSION} ${MULE_HOME}

USER mule

# For checksum, alpine linux needs two spaces between checksum and file name
RUN cd ~ && wget https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/${MULE_VERSION}/mule-standalone-${MULE_VERSION}.tar.gz && \
    echo "${MULE_MD5}  mule-standalone-${MULE_VERSION}.tar.gz" | md5sum -c && \
    cd /opt && \
    tar xvzf ~/mule-standalone-${MULE_VERSION}.tar.gz && \
    rm ~/mule-standalone-${MULE_VERSION}.tar.gz

# Change ownership to mule user
RUN chown mule:mule -R /opt/mule*

# Expose only logs and conf as default volumes, please override apps and domains if required.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf"]

# Set MH as the default work dir
WORKDIR ${MULE_HOME}

CMD [ "/opt/mule/bin/mule"]

# Default mule http port
EXPOSE 8081