FROM alpine:latest

MAINTAINER IanEdington <IanEdington@gmail.com>
ENV LastUpdate 2016-11-13-21-47

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories
RUN echo '@community http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories
RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

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
 editorconfig@community \
 nodejs \
 rust@testing
# mono \

# add npm dependencies
RUN apk add nodejs
RUN npm install -g eslint jshint typescript

# install dotfiles
RUN git clone --depth 1 https://gitlab.com/IanEdington/dotfiles.git ~/.dotfiles

# symlink dotfiles
RUN ln -s ~/.dotfiles/zsh ~/.zsh
RUN ln -s ~/.zsh/zshenv ~/.zshenv
RUN ln -s ~/.dotfiles/vim ~/.vim
RUN ln -s ~/.vim/vimrc ~/.vimrc
RUN ln -s ~/.vim/editorconfig ~/.editorconfig
RUN mkdir -p ~/.config/git
RUN ln -s ~/.dotfiles/git/config ~/.config/git/config
RUN ln -s ~/.dotfiles/git/ignore ~/.config/git/ignore

# download and install prezto for zsh
RUN git clone --depth 1 https://github.com/sorin-ionescu/prezto.git ~/.zsh/.zprezto \
 && cd ~/.zsh/.zprezto \
 && git submodule update --init --remote --recursive
RUN ln -s ~/.zsh/.zprezto/runcoms/zlogin ~/.zsh/.zlogin
RUN ln -s ~/.zsh/.zprezto/runcoms/zlogout ~/.zsh/.zlogout
RUN ln -s ~/.zsh/.zprezto/runcoms/zpreztorc ~/.zsh/.zpreztorc
RUN ln -s ~/.zsh/.zprezto/runcoms/zprofile ~/.zsh/.zprofile
RUN ln -s ~/.zsh/.zprezto/runcoms/zshenv ~/.zsh/.zshenv

# download and install vundle for vim
RUN git clone --depth 1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
 && cd ~/.vim/bundle/Vundle.vim \
 && git submodule update --init --remote --recursive

RUN vim -E -u NONE -S ~/.vim/start_vundle.zshrc +PluginInstall +qall
# RUN mkdir ~/.cache
# RUN vim +PluginInstall +qall

RUN cd ~/.vim/bundle/YouCompleteMe \
 && ./install.py --gocode-completer --tern-completer

# install java
RUN apk add openjdk8

# puts javac in the PATH
ENV PATH=/usr/lib/jvm/java-1.8-openjdk/bin:$PATH

ENTRYPOINT ["zsh"]
