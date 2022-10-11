FROM debian:buster-slim

RUN apt update && apt install -y curl jq xz-utils
RUN curl https://ziglang.org/download/index.json | jq '.master|."x86_64-linux".tarball' > install.url
RUN xargs -n 1 curl -o zig.tar.xz < install.url
RUN tar xvJf zig.tar.xz --strip-components=1 -C /usr/local/bin/


