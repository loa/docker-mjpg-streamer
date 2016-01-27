FROM resin/rpi-raspbian:wheezy

ENV LD_LIBRARY_PATH=. \
    MJPG_STREAMER_DOWNLOAD_URL=https://github.com/jacksonliam/mjpg-streamer/archive/5f6adeefa0d5a78833cc809f2bfa76131f2b9ff8.zip \
    MJPG_STREAMER_DOWNLOAD_SHA1=2e4ab6c2d4c380bbffe6c991b12ebe63abc4e462 \
    MJPG_STREAMER_GITSHA=5f6adeefa0d5a78833cc809f2bfa76131f2b9ff8

RUN set -x; buildDeps='curl ca-certificates build-essential libraspberrypi-dev cmake unzip'; \
    apt-get update && \
    apt-get install -y $buildDeps libjpeg8-dev && \
    curl -sSL "$MJPG_STREAMER_DOWNLOAD_URL" -o mjpg_streamer.zip && \
    echo "$MJPG_STREAMER_DOWNLOAD_SHA1 *mjpg_streamer.zip" | sha1sum -c - && \
    unzip mjpg_streamer.zip && \
    mv mjpg-streamer-${MJPG_STREAMER_GITSHA} /srv/mjpg_streamer && \
    rm mjpg_streamer.zip && \
    cd /srv/mjpg_streamer/mjpg-streamer-experimental && \
    make && \
    apt-get purge -y --auto-remove $buildDeps && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/mjpg_streamer/mjpg-streamer-experimental

ENTRYPOINT [ "./mjpg_streamer", "-i", "./input_uvc.so", "-o", "./output_http.so" ]
