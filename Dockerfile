FROM alpine:3.16

RUN apk update && \
 apk add --no-cache bash easy-rsa git openssh-client curl ca-certificates jq python3 python3-dev py-yaml py3-pip libstdc++ gpgme git-crypt musl-dev build-base && \
 rm -rf /var/cache/apk/*

RUN pip install ijson awscli ruamel.yaml
RUN adduser -h /backup -D backup

ENV KUBECTL_VERSION 1.23.7
ENV KUBECTL_SHA256 b4c27ad52812ebf3164db927af1a01e503be3fb9dc5ffa058c9281d67c76f66e

ENV KUBECTL_URI https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl

RUN curl -SL ${KUBECTL_URI} -o kubectl && chmod +x kubectl

RUN echo "${KUBECTL_SHA256}  kubectl" | sha256sum -c - || exit 10
ENV PATH="/:${PATH}"

COPY entrypoint.sh /
USER backup
ENTRYPOINT ["/entrypoint.sh"]
