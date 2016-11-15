FROM alpine:latest

MAINTAINER IanEdington <IanEdington@gmail.com>

RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories \
 && echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories

RUN apk update \
 && apk upgrade \
 && apk add \
 zsh \
 curl \
 ctags \
 git \
 python \
 bash \
 ncurses-terminfo \
 lua \
 luajit \
 ruby \
 python3 \
 python3-dev \
 go \
 llvm \
 perl \
 perl-dev \
 cmake \
 editorconfig \
 python-dev \
 build-base \
 nodejs \
 rust \
 mono \
 libgcc libstdc++ libuv \
 libxt libx11 libstdc++ \
 python python-dev ctags build-base \
 make libxpm-dev libx11-dev libxt-dev ncurses-dev git \
 libsm libice libxt libx11 ncurses

# Make Vim
RUN cd /tmp \
 && git clone  --depth 1 https://github.com/vim/vim.git
RUN cd /tmp/vim \
 && ./configure --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp=yes \
    --enable-pythoninterp=yes \
    --with-python-config-dir=/usr/lib/python2.7/config \
    --enable-python3interp=yes \
    --with-python3-config-dir=/usr/lib/python3.5/config \
    --enable-perlinterp=yes \
    --enable-luainterp=yes \
    --enable-rubyinterp=yes \
    --with-luajit \
    --disable-gui \
    --enable-cscope \
    --prefix=/usr
RUN cd /tmp/vim \
 && make VIMRUNTIMEDIR=/usr/share/vim/vim80
RUN cd /tmp/vim \
 && make install

# Set env's
ENV GOPATH /home/developer/workspace
ENV GOROOT /usr/lib/go
ENV GOBIN $GOROOT/bin
ENV NODEBIN /usr/lib/node_modules/bin
ENV PATH $PATH:$GOBIN:$GOPATH/bin:$NODEBIN
ENV HOME /home/developer
ENV TERM screen-256color
RUN mkdir -p /home/developer/workspace

# install dotfiles
RUN git clone https://gitlab.com/IanEdington/dotfiles.git ~/.dotfiles
RUN ~/.dotfiles/install

# install java
RUN apk add openjdk8@community

# puts javac in the PATH
ENV PATH=/usr/lib/jvm/java-1.8-openjdk/bin:$PATH

ENTRYPOINT ["zsh"]
