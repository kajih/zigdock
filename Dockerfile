FROM debian:buster-slim AS compiler

RUN apt update && \
    apt install -y curl jq xz-utils

RUN curl https://ziglang.org/download/index.json | jq '.master|."x86_64-linux".tarball' > install.url
RUN xargs -n 1 curl -o zig.tar.xz < install.url

RUN mkdir -p /opt/zig && \
    mkdir -p /zigproj && \
    tar xJf zig.tar.xz -C /opt/zig --strip-components=1

ENV PATH="${PATH}:/opt/zig"

WORKDIR /zigproj

RUN zig init-exe && \
    zig build


FROM debian:buster-slim

WORKDIR /
COPY --from=compiler /zigproj/zig-out/bin/zigproj .
RUN chmod +x zigproj
ENTRYPOINT ["./zigproj"]

