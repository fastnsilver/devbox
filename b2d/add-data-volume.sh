# Convenience script for boot2docker that creates a writable data volume
# that can be shared with any container
# @author Chris Phillipson <fastnsilver@gmail.com>
# @see https://github.com/boot2docker/boot2docker#folder-sharing

# Make a volume container (only need to do this once)
docker run -v /data --name my-data busybox true

# Share it using Samba (Windows file sharing)
docker run --rm -v /usr/local/bin/docker:/docker -v /var/run/docker.sock:/docker.sock svendowideit/samba my-data

  