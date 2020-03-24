FROM node:10.14.1

ENV MINOR_VERSION="2.5"
ENV VERSION="2.5.4"
ENV RUBY_VERSION="ruby-$VERSION"

RUN echo "*******************" && \
    echo "* Installing Ruby *" && \
    echo "*******************" && \
    apt-get -y update && apt-get -y upgrade && \ 
    apt-get install -y autoconf build-essential libreadline-dev libssl-dev libyaml-dev zlib1g-dev libffi-dev && \
    cd /tmp && \
    wget "http://cache.ruby-lang.org/pub/ruby/$MINOR_VERSION/$RUBY_VERSION.tar.gz" && \
    tar -xvzf $RUBY_VERSION.tar.gz && \
    cd $RUBY_VERSION && \
    ./configure --disable-install-doc && \
    make --jobs `nproc` && \
    make install && \
    cd .. && \
    rm $RUBY_VERSION.tar.gz && \
    rm -rf $RUBY_VERSION && \ 
    echo "*******************" && \
    echo "* Ruby installed! *" && \
    echo "*******************"