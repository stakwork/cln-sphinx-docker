# docker buildx build --platform linux/amd64 --load -t cln-sphinx .
#
# Layers:
#   builder  -> compiles the HTLC interceptor plugin (gateway-cln-extension)
#   final    -> official Core Lightning image + that plugin
#
# CLN itself is NOT built here. It comes from the official image, which
# upstream assembles from the signed release tarballs. Pin by digest: the
# v26.06.7 tag served an unpatched image between 28 Aug and 1 Sep 2026.
# Digest table: https://github.com/ElementsProject/lightning/releases/tag/v26.06.7

ARG CLN_IMAGE=elementsproject/lightningd:v26.06.7@sha256:0421a5f0d1b2e1ad639edfa17d777816040e3850d91bae7f2d32186d9c1e6da4

# Builder must match the runtime image's Debian release (glibc).
FROM debian:bookworm-slim AS builder

RUN apt-get update -qq && \
    apt-get install -qq -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    pkg-config \
    protobuf-compiler \
    libssl-dev \
    libclang-dev

ENV RUST_PROFILE=release
ENV PATH=$PATH:/root/.cargo/bin/
# Pinned: the fedimint branch is from April 2024; newer stable may not compile it.
ARG RUST_VERSION=1.84.0
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain ${RUST_VERSION} --profile minimal

# HTLC interceptor: fedimint's gateway-cln-extension with the sphinx patch
# (intercept every HTLC and forward the raw onion).
RUN git clone --depth 1 -b intercept-onion-4 --single-branch https://github.com/stakwork/fedimint.git /tmp/fedimint
RUN cargo build --release \
    --manifest-path /tmp/fedimint/Cargo.toml \
    --config /tmp/fedimint/.cargo/config.toml \
    --bin gateway-cln-extension

FROM ${CLN_IMAGE}

# 26.06.x installs to /usr/libexec/c-lightning and symlinks the old
# /usr/local/libexec/c-lightning path to it. sphinx-swarm passes
#   --plugin=/usr/local/libexec/c-lightning/plugins/gateway-cln-extension
# so make sure that exact path resolves regardless of how the base is laid out.
COPY --from=builder /tmp/fedimint/target/release/gateway-cln-extension /usr/libexec/c-lightning/plugins/gateway-cln-extension
RUN test -x /usr/local/libexec/c-lightning/plugins/gateway-cln-extension || \
    (mkdir -p /usr/local/libexec/c-lightning/plugins && \
     ln -s /usr/libexec/c-lightning/plugins/gateway-cln-extension /usr/local/libexec/c-lightning/plugins/gateway-cln-extension)
