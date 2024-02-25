FROM ubuntu:20.04
LABEL com.centurylinklabs.watchtower.enable="true"
ENV FIRO_VERSION="0.14.13.2"
RUN mkdir -p /root/.firo
RUN apt-get update && apt-get install -y tar wget curl pwgen jq nano
RUN wget https://github.com/firoorg/firo/releases/download/v${FIRO_VERSION}/firo-${FIRO_VERSION}-linux64.tar.gz -O /tmp/firo-linux64.tar.gz
RUN tar xzvf /tmp/firo-linux64.tar.gz -C /tmp --strip-components=1 \
    && cp /tmp/bin/* /usr/local/bin
COPY node_initialize.sh /node_initialize.sh
COPY key.sh /key.sh
COPY check-health.sh /check-health.sh 
VOLUME /root/.firo
RUN chmod 755 node_initialize.sh check-health.sh key.sh
EXPOSE 8168
HEALTHCHECK --start-period=5m --interval=2m --retries=5 --timeout=15s CMD ./check-health.sh
CMD ./node_initialize.sh
