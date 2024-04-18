# FROM debian:bullseye-slim as builder
FROM debian:12-slim as builder

RUN apt-get update -qq && \
    apt-get install -qq -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    wget \
    pkg-config \
    protobuf-compiler \
    libssl-dev \
    libclang-dev

USER root

ENV RUST_PROFILE=release
ENV PATH=$PATH:/root/.cargo/bin/
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN rustup toolchain install stable --component rustfmt --allow-downgrade

WORKDIR /opt/lightningd

# htlc interceptor
RUN git clone -b intercept-onion-4 --single-branch https://github.com/stakwork/fedimint.git /tmp/fedimint
RUN cargo build --release --manifest-path /tmp/fedimint/Cargo.toml --config /tmp/fedimint/.cargo/config.toml --bin gateway-cln-extension

# hsmd broker
RUN git clone https://github.com/stakwork/sphinx-key /tmp/sphinx-key
RUN cargo build --release --manifest-path /tmp/sphinx-key/broker/Cargo.toml

# FROM elementsproject/lightningd:v23.08.1
# FROM elementsproject/lightningd:v24.02-amd64
FROM sphinxlightning/cln:fix-gossip

COPY --from=builder /tmp/fedimint/target/release/gateway-cln-extension /usr/local/libexec/c-lightning/plugins/gateway-cln-extension

COPY --from=builder /tmp/sphinx-key/broker/target/release/sphinx-key-broker /usr/local/libexec/c-lightning/sphinx-key-broker
