# Base image: Use the lightweight Ubuntu-based XFCE image with VNC support
FROM accetto/ubuntu-vnc-xfce-g3:latest

# Expose required ports
EXPOSE 5901 6901 4455

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV VNC_PASSWD=headless
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

# Switch to root user for installation
USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y --fix-broken avahi-daemon xterm git build-essential cmake curl ffmpeg \
    libboost-dev libnss3 mesa-utils qtbase5-dev strace x11-xserver-utils net-tools \
    python3 python3-numpy scrot wget software-properties-common vlc jq udev unrar \
    qt5-image-formats-plugins && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Add OBS Studio repository and install it
RUN add-apt-repository ppa:obsproject/obs-studio && \
    apt-get update && \
    apt-get install -y obs-studio && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Download and install the OBS-NDI plugin
RUN wget -q -O /tmp/libndi4_4.5.1-1_amd64.deb https://github.com/Palakis/obs-ndi/releases/download/4.10.0/libndi4_4.5.1-1_amd64.deb && \
    wget -q -O /tmp/obs-ndi-4.10.0-Ubuntu64.deb https://github.com/Palakis/obs-ndi/releases/download/4.10.0/obs-ndi-4.10.0-Ubuntu64.deb && \
    dpkg -i /tmp/*.deb && \
    rm -rf /tmp/*.deb

# Create necessary directories and fix permissions
RUN mkdir -p /home/headless/.cache /home/headless/Downloads /home/headless/Templates \
    /home/headless/Public /home/headless/Documents /home/headless/Music \
    /home/headless/Pictures /home/headless/Videos && \
    chown -R headless:headless /home/headless && \
    chmod -R 700 /home/headless/.cache

# Copy startup script
COPY startup.sh /dockerstartup/startup.sh
RUN chmod +x /dockerstartup/startup.sh

# Switch back to the headless user
USER headless

# Set the command to start VNC and XFCE
CMD ["/dockerstartup/startup.sh"]
