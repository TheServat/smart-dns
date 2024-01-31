FROM alpine:edge
LABEL maintainer "Amir Hossein 'Roham' Mosalli <rohammosalli@gmail.com>"
# RUN apk add --no-cache  nginx nginx-mod-stream --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/
# RUN sh -c 'mkdir -p /run/openrc/ && mkdir -p /run/nginx'
RUN sh -c 'mkdir -p /run/openrc/'
# COPY nginx.conf /etc/nginx/nginx.conf
RUN apk add --no-cache  curl bash
RUN mkdir -p /etc/sniproxy/


RUN ARCH=$(case ${TARGETPLATFORM:-linux/amd64} in \
    "linux/amd64")   echo "amd64"  ;; \
    "linux/arm/v7")  echo "arm"   ;; \
    "linux/arm64")   echo "arm64" ;; \
    *)               echo ""        ;; esac) \
  && echo "ARCH=$ARCH" \
  && curl -sSL https://github.com/mosajjal/sniproxy/releases/download/v2.0.4/sniproxy-v2.0.4-linux-${ARCH}.tar.gz | tar xvz \
  && chmod +x sniproxy && install sniproxy /usr/local/bin && rm sniproxy

COPY configs/sniproxy/config.yaml /etc/sniproxy/config.yaml
COPY entrypoint.sh /entrypoint.sh

EXPOSE 80 443 53


CMD ["/bin/bash", "/entrypoint.sh"]