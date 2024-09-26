FROM debian
RUN apt-get update && apt-get install -y nginx
RUN apt-get update && apt-get install -y build-essential
# 
RUN apt-get update && apt-get install -y wget
RUN apt-get update && apt-get install -y gnupg gnupg2 gnupg1 
# 
RUN apt-get update && apt-get install -y git
# Install NGINX
WORKDIR /usr/src
RUN wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -zxvf nginx-1.21.6.tar.gz

WORKDIR /usr/src/nginx-1.21.6

# Clone the Nginx VOD module into a specific directory
# RUN git clone https://github.com/kaltura/nginx-vod-module /opt/nginx-vod-module

# RUN find / -name configure ; exit 1
# Configure and build Nginx with the VOD module
# WORKDIR /opt/nginx-vod-module
# RUN /usr/sbin/nginx -V 2>&1 | grep -o -- '--modules-path=[^ ]*' | xargs -I{} ./configure --with-compat --add-dynamic-module=/opt/nginx-vod-module && \
#     make && \
#     make install

RUN git clone https://github.com/kaltura/nginx-vod-module /usr/src/nginx-vod-module
# 
# 4.703 checking for PCRE2 library ... not found
RUN apt-get update && apt-get install -y libpcre3 libpcre3-dev
# 

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpcre3 \
    libpcre3-dev \
    zlib1g \
    zlib1g-dev \
    libssl-dev \
    wget \
    git \
    ffmpeg \
    libxml2-dev \
    libxslt1-dev \
    libgd-dev \
    libgeoip-dev \
    && apt-get clean

RUN ./configure --add-module=/usr/src/nginx-vod-module
RUN make
RUN make install

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
