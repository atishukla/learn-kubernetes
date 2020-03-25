FROM node:10.14.1-stretch


RUN echo "*******************" && \
    echo "* Installing Ruby *" && \
    echo "*******************" && \
    DEBAIN_FRONTEND=noninteractive apt-get update -y && \
    DEBAIN_FRONTEND=noninteractive apt-get install krb5-user -y && \
    DEBAIN_FRONTEND=noninteractive apt-get install -y  ruby-full && \
    echo "*******************" && \
    echo "* Ruby installed! *" && \
    echo "*******************"