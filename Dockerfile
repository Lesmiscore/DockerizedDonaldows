FROM ubuntu

ARG VERSION

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y python-software-properties debconf-utils software-properties-common && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive echo yes | apt-get install -y wine p7zip-full ssh && \
    rm -rf /var/lib/apt/lists && \
    mkdir /var/run/sshd

# Use 32-bit simulator
ENV WINEARCH=win32\ winecfg

ENV DONALDOWS_ARCHIVE donaldows${VERSION}.7z

ADD startup.sh /usr/bin/

CMD startup.sh

RUN set -xe && \
    chmod 4511 `which chpasswd` & \
    groupadd --gid 1000 donaldows && \
    useradd --gid donaldows --uid 1000 --shell '/bin/bash' --create-home donaldows && \
    cat /etc/passwd && \
    mkdir -p /home/donaldows/donaldows && \
    chmod a+x /usr/bin/startup.sh && \
    echo 'donaldows:mcdonald' | chpasswd && \
    sed -i 's/Port 22/Port 3304/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config && \
    sed -i 's/PrintLastLog yes/PrintLastLog no/' /etc/ssh/sshd_config && \
    echo 'if [ -v "\$DISPLAY" ] ; then' >> /home/donaldows/.bashrc && \
    echo 'wine /home/donaldows/donaldows/donaldows.exe' >> /home/donaldows/.bashrc && \
    echo 'else' >> /home/donaldows/.bashrc && \
    echo 'echo アラーッ!' >> /home/donaldows/.bashrc && \
    echo 'fi' >> /home/donaldows/.bashrc && \
    echo 'exit' >> /home/donaldows/.bashrc && \
    touch /home/donaldows/.hushlogin

ADD ${DONALDOWS_ARCHIVE} /home/donaldows/donaldows

RUN cd /home/donaldows/donaldows/ && \
    7z x ${DONALDOWS_ARCHIVE} && \
    chown -R donaldows:donaldows /home/donaldows

EXPOSE 3304
# For testing
#EXPOSE 22
