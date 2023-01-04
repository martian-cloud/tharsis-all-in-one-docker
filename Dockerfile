FROM registry.gitlab.com/infor-cloud/martian-cloud/tharsis/tharsis-api/api:latest AS tharsis-base
ARG kcversion

ENV KC_VERSION ${kcversion}
ENV PGDATA /var/lib/postgresql/data

# Install dependencies.
RUN apk update && apk upgrade && \
    apk add curl bash postgresql supervisor && \
    apk add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --no-cache

# Configure Postgres.
RUN (addgroup -g 1000 -S postgres && adduser -u 1000 -S postgres -G postgres || true) && \
    mkdir -p /var/lib/postgresql/data && \
    mkdir -p /run/postgresql/ && \
    chown -R postgres:postgres /run/postgresql/ && \
    chmod -R 750 /var/lib/postgresql/data && \
    chown -R postgres:postgres /var/lib/postgresql/data && \
    su - postgres -c "initdb /var/lib/postgresql/data" && \
    echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf && \
    su - postgres -c "pg_ctl start -D /var/lib/postgresql/data -l /var/lib/postgresql/log.log && psql --command \"ALTER USER postgres WITH ENCRYPTED PASSWORD 'postgres';\" && psql --command \"CREATE DATABASE tharsis;\""

# Configure minio server and client (for initializing bucket).
RUN curl -fSsL -o /opt/minio https://dl.min.io/server/minio/release/linux-amd64/minio && \
    curl -fSsL -o /opt/mc https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod +x /opt/minio && \
    chmod +x /opt/mc

# Configure supervisor.
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure Keycloak.
RUN cd /tmp || exit 1 && \
    curl -fSsL -o keycloak.tar.gz https://github.com/keycloak/keycloak/releases/download/"${KC_VERSION}"/keycloak-"${KC_VERSION}".tar.gz && \
    mkdir -p /opt/keycloak && \
    tar -xzf keycloak.tar.gz -C /opt/keycloak --strip-components=1 && \
    rm -rf keycloak.tar.gz && \
    addgroup -g 1000 -S keycloak &&  \
    adduser -u 1000 -D -h /opt/keycloak -s /sbin/nologin -G keycloak keycloak  && \
    chown -R keycloak: /opt/keycloak && \
    chmod o+x /opt/keycloak/bin/

COPY --chown=keycloak:keycloak tharsis-realm.json /opt/keycloak/data/import/tharsis-realm.json

WORKDIR /app/
EXPOSE 8000 8080
CMD ["/usr/bin/supervisord","-c", "/etc/supervisor/conf.d/supervisord.conf"]
