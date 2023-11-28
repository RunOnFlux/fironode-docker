
ARG UBUNTUVER=20.04
FROM ubuntu:${UBUNTUVER}
LABEL com.centurylinklabs.watchtower.enable="true"

RUN mkdir -p /root/.firo
RUN apt-get update && apt-get install -y  tar wget curl pwgen jq
RUN wget https://github.com/firoorg/firo/releases/download/v0.14.13.0/firo-0.14.13.0-linux64.tar.gz -P /tmp
RUN tar xzvf /tmp/firo-0.14.13.0-linux64.tar.gz -C /tmp \
&& cp /tmp/firo-39c41e5e7ec6/bin/* /usr/local/bin
COPY node_initialize.sh /node_initialize.sh
COPY check-health.sh /check-health.sh
VOLUME /root/.firo
RUN chmod 755 node_initialize.sh check-health.sh
EXPOSE 8168
HEALTHCHECK --start-period=5m --interval=2m --retries=5 --timeout=15s CMD ./check-health.sh
CMD ./node_initialize.sh
