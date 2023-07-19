FROM debian:buster

RUN apt update
RUN apt install -y nginx openssl

EXPOSE 443
# EXPOSE 80

COPY ./conf/nginx.conf      /etc/nginx/conf.d

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -days 365 -nodes -keyout /etc/nginx/ssl/pratanac.key -out /etc/nginx/ssl/pratanac.crt -subj "/C=TH/ST=Bangkok/L=Bangkok/O=42/OU=pratanac/CN=pratanac"

# nginx config
RUN mkdir -p /run/nginx

RUN ln -sf /dev/stdout /var/log/nginx/access.log      &&  \
    ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["nginx", "-g", "daemon off;"]