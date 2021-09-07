FROM debian:stable-slim
LABEL maintainer.0="Stephen Lester (@burninmedia)" 

# ARGs
ARG PUB_PGP_HASH="59CAF0E96F23F53747945FD4FE3348877809386C"
ARG VERSION="0.18.1"
ARG ARG_KEY="FE3348877809386C"
ENV LITECOIN_DATA=/home/litecoin/.litecoin
ENV LITECOIN_VERSION=$VERSION
ENV GOSU_VERSION=1.10
ENV GPG_KEY=$ARG_KEY
WORKDIR /tmp
RUN useradd -r litecoin \
		&& mkdir /home/litecoin

# Install some basic tools and get gpg keys
RUN apt-get update; \
	apt-get -y install \
	curl \
	gnupg \
	gpg \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN echo "Importing GPG signature and checking download."

# From: https://github.com/uphold/docker-litecoin-core/blob/master/0.18/Dockerfile
# This is a loop through keys attepmting to download them from each fo the keyservers listed below.

RUN for key in \
    $GPG_KEY \
    B42F6819007F00F88E364FD4036A9C25BF357DD4  \
  ; do \
  	echo "Trying to find key: $key"; \
    gpg --no-tty --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --no-tty --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --no-tty --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --no-tty --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    exit 1; \
  done

#### Source: https://github.com/uphold/docker-litecoin-core/blob/master/0.18/Dockerfile
# The core use case for gosu is to step down from root to a non-privileged user during container startup (specifically in the ENTRYPOINT, usually).
RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu



# Download litecoin binary and GPG key
RUN echo "## Downloading litecoin $LITECOIN_VERSION"
RUN curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
		&& curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
		&& gpg  --no-tty --verify litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
		&& grep $(sha256sum litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz | awk '{ print $1 }') litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
		&& tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
		&& rm *.tar.gz
#### EndSource : https://github.com/uphold/docker-litecoin-core/blob/master/0.18/Dockerfile

# Clean up after ourselves.
RUN apt-get remove -y \
	gpg \
	curl \
	&& rm -rf /var/lib/apt/lists/* /tmp/*


COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/litecoin/.litecoin"]

EXPOSE 9332 9333 19332 19333 19444
ENTRYPOINT ["/entrypoint.sh"]
CMD ["litecoind"] 