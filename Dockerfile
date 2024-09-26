# Download this project:
# https://github.com/jemacchi/geoserver-shell
# and build next base docker image running command  ./build.sh
FROM jemacchi/geoserver-shell:0.4.2-SNAPSHOT as builder
#
# NODE INSTALLATION and WETTY BUILD
# Based in https://github.com/svenihoney/docker-wetty-alpine
#
RUN apk --update --no-cache add nodejs npm yarn
RUN apk add -U build-base python git
WORKDIR /app
RUN git clone https://github.com/butlerx/wetty --branch v1.3.0 /app && \
    yarn && \
    yarn build && \
    yarn install --production --ignore-scripts --prefer-offline


FROM jemacchi/geoserver-shell:0.4.2-SNAPSHOT
LABEL maintainer="jose.macchi@gmail.com"

#
# SSH server side
# Based on https://github.com/sickp/docker-alpine-sshd
# 
COPY ./startup.sh /
COPY ./start-gsshell.sh /home/gsshell/

RUN addgroup -S gsshell && adduser -S -D --home /home/gsshell --shell /bin/ash -G gsshell gsshell \
    && echo "gsshell:geoserver" | chpasswd
RUN apk --update --no-cache add nodejs npm yarn
RUN apk add --no-cache openssh \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:root" | chpasswd

# WETTY INSTALL
# Based on https://github.com/svenihoney/docker-wetty-alpine
WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/index.js /app/index.js
RUN apk add -U openssh-client sshpass

# Default ENV params used by wetty
ENV REMOTE_SSH_SERVER=127.0.0.1 \
    REMOTE_SSH_PORT=22 \
    WETTY_PORT=3000

EXPOSE 22 3000

CMD ["/startup.sh"]
