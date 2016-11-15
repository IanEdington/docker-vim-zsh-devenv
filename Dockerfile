FROM alpine:latest

MAINTAINER IanEdington <IanEdington@gmail.com>
ENV LastUpdate 2016-11-13-21-47

RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories

RUN apk update \
 && apk upgrade \
 && apk add \
 bash \
 build-base \
 curl \
 ctags \
 cmake \
 ctags \
 git \
 go \
 llvm \
 lua \
 luajit \
 make \
 ncurses \
 ncurses-dev \
 ncurses-terminfo \
 python \
 python-dev \
 python3 \
 python3-dev \
 perl \
 perl-dev \
 ruby \
 zsh \
 libice \
 libgcc \
 libstdc++ \
 libsm \
 libuv \
 libx11 \
 libx11-dev \
 libxpm-dev \
 libxt \
 libxt-dev

# Make Vim
RUN cd /tmp \
 && git clone  --depth 1 https://github.com/vim/vim.git

RUN ln -s /usr/lib/python3.5/config-3.5m/ /usr/lib/python3.5/config

# Build VIM
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

# npm doesn't want to work
RUN apk add \
 the_silver_searcher \
 nodejs
# editorconfig \
# rust \
# mono \

# add npm dependencies
RUN apk add nodejs
RUN npm install -g eslint jshint typescript

# install dotfiles
RUN git clone https://gitlab.com/IanEdington/dotfiles.git ~/.dotfiles
RUN ~/.dotfiles/install

# install java
RUN apk add openjdk8@community

# puts javac in the PATH
ENV PATH=/usr/lib/jvm/java-1.8-openjdk/bin:$PATH

ENTRYPOINT ["zsh"]
