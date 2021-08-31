FROM ubuntu:20.04
# ARGs
ARG PUB_PGP_HASH="59CAF0E96F23F53747945FD4FE3348877809386C"
ARG VERSION="0.18.1"

WORKDIR /tmp

# Install some basic tools
RUN apt-get update; \
	apt-get -y install wget \
	gpg \
	&& rm -rf /var/lib/apt/lists/*
RUN echo "Importing GPG signature and checking download."
RUN gpg --keyserver pgp.mit.edu --recv-key FE3348877809386C
RUN gpg --list-keys ${PUB_PGP_HASH}
RUN if [ -z $(gpg --list-keys ${PUB_PGP_HASH}) ] ; then \
		echo "!!!!WARNING! GPG PUB KEY HASH DOES NOT MATCH TRUSTED HASH ${PUB_PGP_HASH}!!!!!";\
		exit 1\
	else \
		echo "OK-GPG PUB KEY HASH MATCHES KNOWN HASH ${PUB_PGP_HASH}";\
	fi

# Download binary and GPG key
RUN echo "## Downloading litecoin $VERSION"
RUN wget https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-x86_64-linux-gnu.tar.gz -P /tmp
RUN wget https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-x86_64-linux-gnu.tar.gz.asc -P /tmp

# Verify binary signature matches GPG key.
RUN if [ -z $(gpg --verify litecoin-${VERSION}-x86_64-linux-gnu.tar.gz.asc) ] ; then \
		echo "OK-GPG PUB KEY HASH MATCHES DOWNLOADED FILE";\
	else \
		echo "!!!!WARNING! GPG SIGNATURE DOES NOT MATCH DOWNLOADED FILE!!!!!" ;\
		exit 1;\
	fi

# Install litecoind
RUN mkdir /app; \
	tar xfv litecoin-${VERSION}-x86_64-linux-gnu.tar.gz -C /app; \
	ln -s "/app/litecoin/" "/app/litecoin-${VERSION}"

# Clean up after ourselves.
RUN apt-get remove -y \
	gpg \
	wget \
	&& rm -rf /var/lib/apt/lists/* /tmp/*
RUN adduser litecoind-service

USER litecoind-service
CMD ["/app/litecoin/bin/litecoind"]