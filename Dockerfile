# Base image for building
FROM ubuntu:20.04 AS build

# Set environment variables to prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

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

# Install NGINX
WORKDIR /usr/src
RUN wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -zxvf nginx-1.21.6.tar.gz

# Clone the nginx-vod-module from GitHub
RUN git clone https://github.com/kaltura/nginx-vod-module.git

# Build NGINX with the VOD module
WORKDIR /usr/src/nginx-1.21.6
RUN ./configure --prefix=/etc/nginx \
    --add-module=/usr/src/nginx-vod-module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-threads \
    --with-file-aio \
    --with-http_secure_link_module \
    --with-http_gzip_static_module \
    --with-cc-opt="-O3 -mpopcnt" && \
    make && \
    make install
# RUN find / -name nginx ; exit 1
# 0.609 /etc/nginx                                                                                                                  
# 0.609 /etc/nginx/sbin/nginx
# 0.609 /usr/src/nginx-1.21.6/objs/nginx

# Create a new stage for the final image to keep it small
FROM ubuntu:20.04

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libpcre3 \
    zlib1g \
    openssl \
    ffmpeg \
    && apt-get clean

# Copy NGINX from the build stage
COPY --from=build /etc/nginx /etc/nginx
COPY --from=build /usr/src/nginx-1.21.6/objs/nginx /usr/local/sbin/nginx

# Add basic NGINX config
RUN mkdir -p /etc/nginx/conf.d
# COPY ./nginx .

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/conf/nginx.conf

# RUN nginx -g 'daemon off;'
CMD ["nginx", "-g", "daemon off;"]
