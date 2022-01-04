FROM node:14-alpine AS builder
LABEL maintainer="Amir Moradi - https://linkedin/in/amirhmoradi"

ENV npm_config_loglevel=verbose
ENV BOT_OWNER "No owner specified"
ENV BOT_DESC "Hubot with the Rocket.Chat adapter"

USER root
RUN apk add --update \
    git && \
    adduser -S hubot && \
    addgroup -S hubot && \
    touch ~/.bashrc && \
    npm install --global npm@latest && \
    npm install -g coffeescript && \
    mkdir /home/hubot/scripts/

FROM builder AS final

WORKDIR /home/hubot/

COPY package.json /home/hubot/
COPY bin/hubot /home/hubot/bin/
RUN chown -R hubot:hubot /home/hubot/

USER hubot
# EXTERNAL_SCRIPTS is managed in bin/hubot script.
#ENV EXTERNAL_SCRIPTS=hubot-diagnostics,hubot-google-images,hubot-google-translate,hubot-pugme,hubot-maps,hubot-rules,hubot-shipit
RUN npm install --no-audit

VOLUME ["/home/hubot/scripts"]
CMD ["/bin/ash", "/home/hubot/bin/hubot"]