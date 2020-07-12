FROM debian:latest

ENV DISTRIBUTION=debian
# Store inside packages all packaged .deb files. A script runs automatically on every startup of the container which adds the packages to the repository
VOLUME [ "/packages" ]
EXPOSE 80

RUN apt update && apt install -y gnupg \
    wget \
    apache2 \
    reprepro

COPY files/gnupg/key.template /keys
RUN mkdir -p ~/.gnupg/ && \
    chmod 600 ~/.gnupg/ && \
    echo "default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 BZIP2 ZLIB ZIP Uncompressed" >> ~/.gnupg/gpg.conf && \
    echo "cert-digest-algo SHA512" >> ~/.gnupg/gpg.conf
    # Generate key

COPY files/apache/repos /etc/apache2/conf.d/

RUN mkdir -p "/var/www/repos/apt/" && \
    /etc/init.d/apache2 start