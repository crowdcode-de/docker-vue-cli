# simple vue-cli docker installation
# docker build -t vue-cli
# or specify vue-cli version
# build --build-arg VUE_CLI_VERSION= .

FROM node:stretch

# alternative to reduce size instead of alpine, but does not
# include build tools for native compilation of npm packages
# FROM node:8-slim

MAINTAINER CROWDCODE GmbH & Co. KG "development@crowdcode.io"

ARG VUE_CLI_VERSION=2.9.6
ARG USER_HOME_DIR="/tmp"
ARG WORKSPACE_DIR="/workspace"
ARG USER_ID=1000

ENV NPM_CONFIG_LOGLEVEL warn

RUN apt-get update \
   && apt-get install -qqy --no-install-recommends dumb-init \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# npm 5 uses different userid when installing packages, as workaround su to node wenn installing
## see https://github.com/npm/npm/issues/16766

RUN set -xe \
    && curl -sL https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 > /usr/bin/dumb-init \
    && chmod +x /usr/bin/dumb-init \
    && mkdir -p $USER_HOME_DIR \
    && chown $USER_ID $USER_HOME_DIR \
    && chmod a+rw $USER_HOME_DIR \
    && chown -R node /usr/local/lib /usr/local/include /usr/local/share /usr/local/bin \
    && (cd "$USER_HOME_DIR"; su node -c "npm install -gnpm i -g @vue/cli; npm install -g yarn; chmod +x /usr/local/bin/yarn; npm cache clean --force")

# not declared to avoid anonymous volume leak
# VOLUME "$USER_HOME_DIR/.cache/yarn"
# VOLUME "$APP_DIR/"
WORKDIR $WORKSPACE_DIR
EXPOSE 4200

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

USER $USER_ID