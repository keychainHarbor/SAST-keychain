#Using a lightweight base image
FROM debian:bookworm-slim AS build

# Installing all dependencies

## with apt-get
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    openjdk-17-jdk \
    zip \
    unzip \
    sudo \
    openssl \
    bandit \
    openssh-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# bearer
RUN curl -sfL https://raw.githubusercontent.com/Bearer/bearer/main/contrib/install.sh | sh

## spotbugs (and findsecbugs)
RUN wget https://github.com/spotbugs/spotbugs/releases/download/4.8.6/spotbugs-4.8.6.zip && \
    unzip spotbugs-4.8.6.zip && rm spotbugs-4.8.6.zip

RUN wget https://repo1.maven.org/maven2/com/h3xstream/findsecbugs/findsecbugs-plugin/1.13.0/findsecbugs-plugin-1.13.0.jar && \
    mv findsecbugs-plugin-1.13.0.jar spotbugs-4.8.6/plugin && \
    mv spotbugs-4.8.6 /usr/local/spotbugs

## trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.58.0-1-g775f954c3
   
## insider
RUN wget https://github.com/insidersec/insider/releases/download/3.0.0/insider_3.0.0_linux_x86_64.tar.gz && \
    tar -xvf insider_3.0.0_linux_x86_64.tar.gz && rm README.md && mv insider /usr/local/bin
# 3. Installing Go
RUN wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz && \
    rm go1.23.4.linux-amd64.tar.gz && \
    echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile


# 4. Installing Blackdagger
RUN curl -L https://raw.githubusercontent.com/ErdemOzgen/blackdagger/main/scripts/blackdagger-installer.sh -o blackdagger-installer.sh && \
    chmod +x blackdagger-installer.sh && \
    bash blackdagger-installer.sh

EXPOSE 8080 8090

COPY ./entry.sh /entry.sh
COPY ./start.sh /start.sh
RUN sh -c 'cp /usr/local/go/bin/* /usr/bin/'
RUN bash -c "source ~/.bashrc"
RUN chmod +x /entry.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/entry.sh"]