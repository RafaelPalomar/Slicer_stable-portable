# Use the official Debian 12 image as the base
FROM debian:12

# Label the container
LABEL maintainer="rafael.palomar@ous-research.no"
LABEL description="Container with 3D Slicer (Stable Version) for Distrobox"

# Install necessary packages for downloading and extracting 3D Slicer
RUN apt-get update && \
    apt-get install -y wget ca-certificates qt5dxcb-plugin libasound2 libxkbcommon-x11-0 libxtst6 libsm6 libnss3 libglu1-mesa libpulse-mainloop-glib0 && \
    # Create the directory where 3D Slicer will be installed
    mkdir -p /opt/Slicer-stable && \
    # Download 3D Slicer binaries
    wget https://download.slicer.org/bitstream/657813b183a3201b44d4e6f7 -O /opt/Slicer-stable/Slicer.tar.gz && \
    # Extract the downloaded package
    tar -xzvf /opt/Slicer-stable/Slicer.tar.gz -C /opt/Slicer-stable --strip-components=1 && \
    rm /opt/Slicer-stable/Slicer.tar.gz && \
    # Create and enable permissions for the extension manager
    mkdir -p /opt/Slicer-stable/slicer.org && \
    chmod 777 /opt/Slicer-stable/slicer.org && \
    # Clean up cache to reduce layer size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the 3DSlicer.desktop file to the applications directory
COPY 3DSlicer.desktop /usr/share/applications/

# Creating symbolic links for distrobox utilities
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
