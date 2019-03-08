FROM ubuntu:16.04

# Change locale to en_US.UTF-8
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set Timezone
ENV TZ=Europe/Bucharest
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Installing packages required for setup: apt-transport-https, curl...
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y apt-transport-https curl gnupg perl-modules-5.22 git sudo nano jq

# Create node username and group
RUN groupadd node && \
    useradd --gid node --home-dir /home/node --shell /bin/bash --create-home node

# Create personaminer username and group
RUN groupadd personaminer && \
    useradd --gid personaminer --home-dir /home/personaminer --shell /bin/bash --create-home personaminer

# ADD personaminer to sudo
RUN echo "personaminer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Node version we want to install
ENV NODE_VERSION 8.15.0

# Adding the NodeSource signing key...
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -

# Creating apt sources list file for the NodeSource Node.js 8.x repo...
RUN echo 'deb https://deb.nodesource.com/node_8.x xenial main' > /etc/apt/sources.list.d/nodesource.list
RUN echo 'deb-src https://deb.nodesource.com/node_8.x xenial main' >> /etc/apt/sources.list.d/nodesource.list

# Install Node.js 8.x and npm
RUN apt-get update && \
    apt-get install -y nodejs

# Install PM2
RUN npm install pm2@latest -g
RUN npm install grunt-cli -g

# Adding the Yarn signing key...
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

# Creating apt sources list file for the Yarn repo...
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install Yarn
RUN apt-get update && \
    apt-get install -y yarn

# Install devel tools
RUN apt-get update && \
    apt-get install -y gcc g++ make postgresql-common libpq-dev

# Expose the PostgreSQL port
EXPOSE 5001/tcp
EXPOSE 8080/tcp
EXPOSE 4001/tcp
EXPOSE 4101/tcp

# Copy files to img
RUN mkdir -p /opt/scripts
ADD docker-entrypoint.sh /opt/scripts/docker-entrypoint.sh
RUN chown -R personaminer:personaminer /opt/scripts/docker-entrypoint.sh
RUN chmod 0750 /opt/scripts/docker-entrypoint.sh

# Run next commands as personaminer
USER personaminer

# Cloning and installing the Persona node
WORKDIR /home/personaminer
RUN git clone https://github.com/PersonaIam/personatestnet persona-node

# Build node modules
WORKDIR /home/personaminer/persona-node
RUN npm install libpq
RUN npm install secp256k1
RUN npm install bindings
RUN npm install

# Set ENTRYPOINT
ENTRYPOINT ["/opt/scripts/docker-entrypoint.sh"]

# Set the default command to run when starting the container
CMD [""]
