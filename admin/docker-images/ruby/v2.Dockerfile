FROM node:10.14.1-stretch


RUN echo "*******************" && \
    echo "* Installing Ruby *" && \
    echo "*******************" && \
    apt update -y  \ 
    apt install -y  ruby-full && \
    echo "*******************" && \
    echo "* Ruby installed! *" && \
    echo "*******************"