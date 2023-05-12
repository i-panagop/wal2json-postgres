FROM debezium/postgres:15-alpine

# Install build dependencies
RUN apk update && apk add --no-cache build-base git postgresql-dev gcc clang llvm-dev

ENV CC=gcc

# Clone the wal2json repository
RUN git clone https://github.com/eulerto/wal2json.git /tmp/wal2json

# Build and install the wal2json extension
RUN cd /tmp/wal2json \
    && make && make install

# Cleanup
RUN rm -rf /tmp/wal2json

COPY postgresql.conf /tmp/postgresql.conf

COPY updateConfig.sh /docker-entrypoint-initdb.d/_updateConfig.sh

# Expose the PostgreSQL default port
EXPOSE 5432