FROM eavatar/basebox

ADD overlayfs.tar /
RUN echo postgres:x:102:107:PostgreSQL administrator,,,:/var/lib/postgresql:/bin/bash >> /etc/passwd
RUN echo postgres:x:107: >> /etc/group
RUN mkdir -p -m 0700 /var/log/postgresql && chown -R postgres:postgres /var/log/postgresql
RUN mkdir -p -m 0700 /var/lib/postgresql && chown -R postgres:postgres /var/lib/postgresql
RUN chmod a+w /tmp

RUN mkdir -p /etc/service/postgresql
ADD postgresql-run.sh /etc/service/postgresql/run
RUN chmod a+x /*.sh && chmod a+x /etc/service/postgresql/run

# Define mountable directories.
VOLUME ["/var/lib/postgresql"]

# Define working directory.
WORKDIR /var/lib/postgresql


# Expose ports.
EXPOSE 5432
