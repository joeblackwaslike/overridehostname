FROM    callforamerica/debian

MAINTAINER Joe Black <joeblack949@gmail.com>

RUN     apt-get update -qq && \
            apt-get install build-essential -qqy && \
            apt-clean --aggressive

RUN     mkdir -p /build/overridehostname
COPY    entrypoint /

WORKDIR /build/overridehostname

VOLUME  ["/build/overridehostname"]

CMD     ["/entrypoint"]
