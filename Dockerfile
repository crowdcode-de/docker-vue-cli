# simple vue-cli docker installation
# docker build -t vue-cli
# or specify vue-cli version
# build --build-arg VUE_CLI_VERSION= .

FROM node:stretch

# alternative to reduce size instead of alpine, but does not
# include build tools for native compilation of npm packages
# FROM node:8-slim

LABEL maintainer="development@crowdcode.io" \
      description="Simple vue-cli docker container"

ARG VUE_CLI_VERSION=3.5.5 
ENV VUE_CLI_VERSION ${VUE_CLI_VERSION}
ARG USER_ID=1000
ARG USER_HOME_DIR="/build"
ARG WORKSPACE_DIR="/workspace"

ENV NPM_CONFIG_LOGLEVEL info
ENV HOME "$USER_HOME_DIR"

RUN apt-get update \
   && apt-get install -qqy --no-install-recommends dumb-init \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN set -xe \
    && mkdir -p $USER_HOME_DIR \
    && chown $USER_ID $USER_HOME_DIR \
    && chmod a+rw $USER_HOME_DIR \
    && chown -R node /usr/local/lib /usr/local/include /usr/local/share /usr/local/bin \
    &&  (cd "$USER_HOME_DIR"; su node -c "npm install -g @vue/cli@${VUE_CLI_VERSION}; npm install -g yarn; yarn global add @vue/cli-service-global; chmod +x /usr/local/bin/yarn; npm cache clean --force")


# not declared to avoid anonymous volume leak
# VOLUME "$USER_HOME_DIR/.cache/yarn"
# VOLUME "$APP_DIR/"
WORKDIR $WORKSPACE_DIR

EXPOSE 8000
 
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

USER ${USER_ID}