ARG BASE_IMAGE

FROM rust:slim-buster AS builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y musl-tools pkg-config

ENV ARC="aarch64-unknown-linux-gnu"
RUN rustup target add "${ARC}"
ARG MDBOOK_VERSION
RUN cargo install mdbook --version "${MDBOOK_VERSION}" --target "${ARC}"
RUN cargo install mdbook-mermaid mdbook-wikilinks mdbook-extended-markdown-table

RUN apt-get install --no-install-recommends -y libssl-dev
RUN cargo install mdbook-kroki-preprocessor

FROM $BASE_IMAGE
 
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
COPY --from=builder /usr/local/cargo/bin/mdbook /usr/bin/mdbook
COPY --from=builder /usr/local/cargo/bin/mdbook-mermaid /usr/bin/mdbook-mermaid
COPY --from=builder /usr/local/cargo/bin/mdbook-wikilinks /usr/bin/mdbook-wikilinks
COPY --from=builder /usr/local/cargo/bin/mdbook-extended-markdown-table /usr/bin/mdbook-extended-markdown-table
COPY --from=builder /usr/local/cargo/bin/mdbook-kroki-preprocessor /usr/bin/mdbook-kroki-preprocessor

WORKDIR /book
ENTRYPOINT [ "/usr/bin/mdbook" ]
