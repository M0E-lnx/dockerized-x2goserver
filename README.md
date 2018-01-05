# x2goserver ( in a docker container )
Docker container for running x2goserver

This will create a docker image that runs an isolated minimal
desktop on x2goserver and which is available to connect to remotely.

# About The Image
- WARNING:  The resulting image is almost 1GB in size!!!
  The resulting desktop features the jwm window manager, plus a few
  applications.  More apps can be added if desired.

- This image is based on ubuntu arm, but can be easily changed to
  a 32-bit or 64-bit system by changing the 'FROM' line on Dockerfile.

- About etc-ssh.tar.xz file: This is used to install persistent host
  ssh keys.  This helps prevent connection errors about host key
  changes when you have to rebuild the image.  If you wan to use this,
  you'll need to generate the keys ( /etc/ssh/ssh_host* ), and pack
  them into this file.  If you prefer not to use persistent keys, 
  simply comment this line on the Dockerfile.

- About the run.sh script: This provides a quick and dirty way to
  start the docker container.  Not entirely necessary if you prefer
  to start your containers a different method, have at it.

# Persistent $HOME data
It is possible to save your $HOME dir from your docker container back
to the host so that it survives image re-generations and container 
restarts.  To accomplish this, you can run the container without 
the persistent home dir mounted, but mount some dir to /app/data or somewhere.
You can ssh into the cointaner and rsync the contents of your $HOME to
the mounted dir.  Once the data is saved, you can restart the container with
the existing data mounted to /home/x2gouser in the container (see run.sh)

# Known issues
- Some apps crash when running inside a docker container, and some just
  refuse to run.  A notable example of this is the chromium browser.

- The included vivaldi and qupzilla browsers will crash randomly at times.

# Connecting to the dockerized-x2goserver
To connect to the running instance:

- Point your x2goclient to the target host
  - This would be localhost or 127.0.0.1 if you're running the container
    on the same box you're connecting from or have tunnelled ssh ports.
- Enter the username on the login field (defaults to x2gouser)
- Enter the port number you're connecting to (defaults to 56 which is
  mapped to the docker containers port 22 for ssh)
- On the 'Session type' area of the connection dialog, select 'Custom desktop'
  and for 'Command' type '/usr/bin/startx-jwm.sh'

