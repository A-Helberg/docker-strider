FROM node:latest

MAINTAINER Andre Helberg <helberg.andre@gmail.com>

EXPOSE 3000

ENV STRIDER_VERSION=master STRIDER_GIT_SRC=https://github.com/Strider-CD/strider.git STRIDER_HOME=/data STRIDER_SRC=/opt/strider
ENV NODE_ENV production

VOLUME [ "$STRIDER_HOME" ]

RUN mkdir -p $STRIDER_SRC && cd $STRIDER_SRC && \
    # Checkout into $STRIDER_SRC
    git clone $STRIDER_GIT_SRC . && \
    [ "$STRIDER_VERSION" != 'master' ] && git checkout tags/$STRIDER_VERSION || git checkout master && \
    rm -rf .git && \
    # Install NPM deps
    npm install && \
    # Create link to strider home dir so the modules can be used as a cache
    mv node_modules node_modules.cache && ln -s ${STRIDER_HOME}/node_modules node_modules && \
    # Cleanup Upstream cruft
    rm -rf /tmp/*

ENV PATH ${STRIDER_SRC}/bin:$PATH

COPY entry.sh /
ENTRYPOINT ["/entry.sh"]
CMD ["strider"]
