FROM node:10.14.1

ENV MINOR_VERSION="2.5"
ENV VERSION="2.5.7"
ENV RUBY_VERSION="ruby-$VERSION"

RUN echo "*******************" && \
    echo "* Installing Ruby *" && \
    echo "*******************" && \
    apt update && apt upgrade -y && \ 
    apt install -y  ruby && \
    echo "*******************" && \
    echo "* Ruby installed! *" && \
    echo "*******************"