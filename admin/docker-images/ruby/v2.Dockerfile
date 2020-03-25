FROM node:10.14.1-stretch


RUN echo "*******************" && \
    echo "* Installing Ruby *" && \
    echo "*******************" && \
    apt-get update -y && \
    apt-get install krb5-user -y && \
    apt-get install -y  ruby-full && \
    echo "*******************" && \
    echo "* Ruby installed! *" && \
    echo "*******************"