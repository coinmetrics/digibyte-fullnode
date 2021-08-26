FROM ubuntu:20.04

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
	; \
	rm -rf /var/lib/apt/lists/*

ARG VERSION
ARG VERSION_SHORT

RUN curl -L https://github.com/DigiByte-Core/digibyte/releases/download/v${VERSION}/digibyte-${VERSION_SHORT}-x86_64-linux-gnu.tar.gz | tar -xkz --strip-components=1 -C /

RUN useradd -m -u 1000 -s /bin/bash runner
USER runner

ENTRYPOINT ["digibyted"]
