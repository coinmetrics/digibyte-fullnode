FROM ubuntu:20.04 AS builder

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        git \
        libtool \
        autotools-dev \
        automake \
        pkg-config \
        libssl-dev \
        libevent-dev \
        bsdmainutils \
        python3 \
        libboost-system-dev \
        libboost-filesystem-dev \
        libboost-chrono-dev \
        libboost-test-dev \
        libboost-thread-dev \
	; \
	rm -rf /var/lib/apt/lists/*

# sudo apt-get install libzmq3-dev  # ZMQ dependencies (provides ZMQ API 4.x)

RUN useradd -m -s /bin/bash builder
USER builder

ARG VERSION

# source
RUN set -ex; \
  git clone -b v${VERSION} --depth 1 --recursive https://github.com/DigiByte-Core/digibyte.git /home/builder/digibyte

# build
RUN set -ex; \
  cd /home/builder/digibyte; \
  ./autogen.sh; \
  ./configure --enable-hardening --without-gui --without-miniupnpc --disable-wallet; \
  make check -j$(nproc)

FROM ubuntu:20.04

RUN useradd -m -u 1000 -s /bin/bash runner
USER runner

COPY --from=builder /home/builder/digibyte/bin/digibyted /usr/bin/

ENTRYPOINT ["digibyted"]
