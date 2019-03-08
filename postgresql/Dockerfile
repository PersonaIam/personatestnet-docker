FROM debian

# Set version
ENV PG_VERSION 9.6

# Install Term/ReadLine.pm
RUN apt-get update && apt-get install -y perl-modules-5.24 sudo nano && rm -rf /var/lib/apt/lists/*

# change locale to en_US.UTF-8
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set Timezone
ENV TZ=Europe/Bucharest
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#  Install Postgresql
RUN apt-get update && apt-get install -y postgresql-$PG_VERSION postgresql-client-$PG_VERSION postgresql-contrib-$PG_VERSION gosu && rm -rf /var/lib/apt/lists/*

RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/${PG_VERSION}/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/${PG_VERSION}/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

ENV PATH $PATH:/usr/lib/postgresql/$PG_VERSION/bin
ENV PGDATA /var/lib/postgresql/$PG_VERSION/main
ENV PG_CONFIG /etc/postgresql/$PG_VERSION/main/postgresql.conf

RUN mkdir -p /var/run/postgresql/$PG_VERSION-main.pg_stat_tmp && chown -R postgres:postgres /var/run/postgresql

# Copy files to img
RUN mkdir -p /opt/scripts
ADD docker-entrypoint.sh /opt/scripts/docker-entrypoint.sh

# Set ENTRYPOINT
ENTRYPOINT ["/opt/scripts/docker-entrypoint.sh"]

# Set the default command to run when starting the container
CMD [""]
