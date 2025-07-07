FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    xfce4 xfce4-terminal tigervnc-standalone-server supervisor dbus-x11 xdg-utils \
    python3 python3-websockify python3-flask python3-qrcode net-tools wget && \
    rm -rf /var/lib/apt/lists

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates idle3 mousepad && \
    rm -rf /var/lib/apt/lists

COPY novnc /opt/novnc
RUN ln -s /opt/novnc/vnc.html /opt/novnc/index.html

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user/.vnc && \
    echo '#!/bin/bash\nstartxfce4 &' > /home/user/.vnc/xstartup && \
    chmod +x /home/user/.vnc/xstartup && \
    chown -R user:user /home/user

RUN chmod u+s $(which python3)

COPY supervisord.conf /etc/

EXPOSE 8080

ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord"]
