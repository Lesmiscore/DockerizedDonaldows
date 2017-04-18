FROM ubuntu

ARG VERSION

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wine p7zip-full ssh && \
    rm -rf /var/lib/apt/lists

# Use 32-bit simulator
ENV WINEARCH=win32\ winecfg

RUN mkdir -p /usr/donaldows/

ENV DONALDOWS_ARCHIVE donaldows${VERSION}.7z

ADD ${DONALDOWS_ARCHIVE} /usr/donaldows/
ADD startup.sh /usr/bin/

RUN cd /usr/donaldows/ && \
    7z x ${DONALDOWS_ARCHIVE} && \
    chmod a+x /usr/bin/startup.sh

CMD startup.sh
