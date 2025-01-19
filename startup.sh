#!/bin/bash

# Start the VNC server
tightvncserver :1 -geometry ${VNC_RESOLUTION} -depth ${VNC_COL_DEPTH} -rfbport 5901 -rfbauth /home/headless/.vnc/passwd

# Launch the Xfce desktop environment
startxfce4 &
