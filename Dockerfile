FROM debian:bookworm-slim AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends ocaml-nox make gcc libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY Makefile *.ml ./
RUN make

FROM debian:bookworm-slim AS runtime

# coreutils supplies stty for the interactive keyboard mode.
RUN apt-get update \
    && apt-get install -y --no-install-recommends coreutils \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --uid 10001 app

WORKDIR /app
COPY --from=build /src/ft_ality /app/ft_ality
COPY grammars/ /app/grammars/

USER app
ENTRYPOINT ["/app/ft_ality"]
CMD ["grammars/arena.gmr"]
