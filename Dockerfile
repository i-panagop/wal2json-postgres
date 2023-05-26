FROM debezium/postgres:15-alpine

# Install build dependencies
RUN apk update && apk add --no-cache build-base make git gcc libc-dev clang llvm

ENV CC gcc

ENV MUSL_LOCALE_DEPS cmake make musl-dev gcc gettext-dev libintl
ENV MUSL_LOCPATH /usr/share/i18n/locales/musl

RUN apk add --no-cache \
    $MUSL_LOCALE_DEPS \
    && wget https://gitlab.com/rilian-la-te/musl-locales/-/archive/master/musl-locales-master.zip \
    && unzip musl-locales-master.zip \
      && cd musl-locales-master \
      && cmake -DLOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install \
      && cd .. && rm -r musl-locales-master

# Clone the wal2json repository
RUN git clone https://github.com/eulerto/wal2json.git /tmp/wal2json

# Build and install the wal2json extension
RUN cd /tmp/wal2json \
    && make && make install

# Cleanup
RUN rm -rf /tmp/wal2json

COPY postgresql.conf.sample /usr/local/share/postgresql/postgresql.conf.sample

# Expose the PostgreSQL default port
EXPOSE 5432