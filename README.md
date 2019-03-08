## PersonaIam testnet on Docker

<p align="center">
    <img src="./persona.png" width="100%" height="100%" />
</p>


This repository contains Docker files of [PersonaIam](https://github.com/PersonaIam/personatestnet) and [PostgreSQL](https://www.postgresql.org) for [Docker](https://www.docker.com/)'s [automated build](https://cloud.docker.com/repository/docker/personablockchain/core) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).


### Base Docker Images

* [dockerhub/ubuntu 16.04](https://hub.docker.com/_/ubuntu)
* [dockerhub/debian](https://hub.docker.com/_/debian)


### PersonaIam Relay

Run Relay node using Docker Compose

1. Install [Docker](https://www.docker.com/).

2. Create file "docker-compose.yml" with the following content.

```bash
version: '2'
services:
  pg-persona:
    image: personablockchain/core:pg_persona_testnet
    container_name: pg-persona-testnet
    restart: always
    ports:
      - '127.0.0.1:5432:5432'
    volumes:
      - db-data:/var/lib/postgresql/9.6/main
    networks:
      - persona-testnet-net
    environment:
      DB_PASSWORD: password
      DB_NAME: persona_testnet
      DB_USER: personaminer
  persona-node:
    image: personablockchain/core:node_persona_testnet
    container_name: node-persona-testnet
    restart: always
    ports:
      - "4001:4001"
      - "4101:4101"
      - "127.0.0.1:5001:5001"
      - "127.0.0.1:8080:8080"
    cap_add:
      - SYS_NICE
      - SYS_RESOURCE
      - SYS_TIME
    volumes:
      - persona-node:/home/personaminer/persona-node
    networks:
      - persona-testnet-net
    environment:
      NETWORK: testnet
      DB_HOST: pg-persona-testnet
      DB_USER: personaminer
      DB_PASSWORD: password
      DB_NAME: persona_testnet
    tty: true
    links:
     - pg-persona
    depends_on:
     - pg-persona
volumes:
  db-data:
  persona-node:
networks:
  persona-testnet-net:
```

3. Adjust the following variables for both services if you prefer to use your own.

```bash
DB_NAME
DB_USER
DB_PASSWORD
```

4. Start the node. In the same folder where you created the file "docker-compose.yml" run.

```bash
docker-compose up -d
```

5. Check if both containers are running.

```bash
docker container ls
```

## If you prefer to build the images yourself

1. Install [Docker](https://www.docker.com/).

2. Clone the repository from git.

```bash
git clone https://github.com/PersonaIam/personatestnet-docker.git personaim-docker
```

3. Build postgresql image.

```bash
cd postgresql
docker build -t pg_persona_testnet .
docker image ls
```

4. Build persona-node.

```bash
cd persona-node
docker build -t node_persona_testnet .
docker image ls
```

5. Create file "docker-compose.yml" with the following content.

```bash
version: '2'
services:
  pg-persona:
    image: pg_persona_testnet
    container_name: pg-persona-testnet
    restart: always
    ports:
      - '127.0.0.1:5432:5432'
    volumes:
      - db-data:/var/lib/postgresql/9.6/main
    networks:
      - persona-testnet-net
    environment:
      DB_PASSWORD: password
      DB_NAME: persona_testnet
      DB_USER: personaminer
  persona-node:
    image: node_persona_testnet
    container_name: node-persona-testnet
    restart: always
    ports:
      - "4001:4001"
      - "4101:4101"
      - "127.0.0.1:5001:5001"
      - "127.0.0.1:8080:8080"
    cap_add:
      - SYS_NICE
      - SYS_RESOURCE
      - SYS_TIME
    volumes:
      - persona-node:/home/personaminer/persona-node
    networks:
      - persona-testnet-net
    environment:
      NETWORK: testnet
      DB_HOST: pg-persona-testnet
      DB_USER: personaminer
      DB_PASSWORD: password
      DB_NAME: persona_testnet
    tty: true
    links:
     - pg-persona
    depends_on:
     - pg-persona
volumes:
  db-data:
  persona-node:
networks:
  persona-testnet-net:
```

6. Adjust the following variables for both services if you prefer to use your own.

```bash
DB_NAME
DB_USER
DB_PASSWORD
```

7. Start the node. In the same folder where you created the file "docker-compose.yml" run.

```bash
docker-compose up -d
```

8. Check if both containers are running.

```bash
docker container ls
```
