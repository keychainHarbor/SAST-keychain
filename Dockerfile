# 1. Using a lightweight base image
FROM debian:slim AS build

# 2. Installing the required dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    openjdk-11-jdk \
    zip \
    unzip \
    sudo \
    openssl \
    bandit \
    sonar-scanner \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Installing Go
RUN wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz && \
    rm go1.23.4.linux-amd64.tar.gz && \
    echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile


# 4. Installing Blackdagger
RUN curl -L https://raw.githubusercontent.com/ErdemOzgen/blackdagger/main/scripts/blackdagger-installer.sh -o blackdagger-installer.sh && \
    chmod +x blackdagger-installer.sh && \
    ./blackdagger-installer.sh

EXPOSE 8080 8090

COPY ./entry.sh /entry.sh
COPY ./start.sh /start.sh
RUN sh -c 'cp /root/go/bin/* /usr/bin/'
RUN source ~/.bashrc
RUN chmod +x /entry.sh
ENTRYPOINT ["/entry.sh"]