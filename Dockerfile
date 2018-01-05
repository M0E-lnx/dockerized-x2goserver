FROM arm32v7/ubuntu:artful
ARG DEBIAN_FRONTEND=noninteractive
ARG user=x2gouser
ARG pw=secret

EXPOSE 22
EXPOSE 8080-8085

# update and enable package cache (necessary for package installations)
RUN apt update && \
  apt install -y software-properties-common wget dialog && \
  add-apt-repository ppa:x2go/stable

ADD vivaldi.repo /etc/apt/sources.list.d/vivaldi.list
RUN \
  wget -qO- http://repo.vivaldi.com/stable/linux_signing_key.pub | apt-key add - && \
  apt update && \
  apt upgrade -y && \
  apt-get install -y xorg jwm hexchat xfonts-100dpi xfonts-75dpi xfonts-base \
    x2goserver ssh x2goserver-xsession x2golxdebindings dos2unix \
    language-pack-en htop lxterminal git \
    sudo rsync vim \
    qupzilla python2.7 python-requests locales \
    gconf-service fonts-liberation xdg-utils vivaldi-stable && \
  apt-get autoremove -y && \
  apt-get autoclean -y && \
  update-locale LANG=en_US.UTF-8

# add user
RUN \
useradd -ms /bin/bash ${user} && \
echo ${user}:${pw} | chpasswd && \
usermod -aG sudo ${user}

# workaround for SSH agent forwarding in X2Go 1
ADD \
  x2go/workaround.bash.bashrc /tmp/workaround.bash.bashrc 
# docker-compose compat
ADD \
  cinit.sh /tmp/cinit.sh

# File endings fix (Windows compatibility)
RUN \
  dos2unix /tmp/workaround.bash.bashrc && \
  apt-get --purge remove -y dos2unix && \
  apt-get autoremove -y

# workaround for SSH agent forwarding in X2Go 2
RUN \
cat /tmp/workaround.bash.bashrc >> /etc/bash.bashrc

# copy public SSH key
COPY \
  ssh/* /home/${user}/.ssh/

# Only SSH for login and set correct permissions
RUN \
  chown -R ${user} /home/${user}/.ssh/ && chmod 600 /home/${user}/.ssh/* 

# Set locale to en_US.utf-8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ADD etc-ssh.tar.xz /
ADD startx-jwm.sh /usr/bin/startx-jwm.sh
CMD [ "/tmp/cinit.sh" ]

