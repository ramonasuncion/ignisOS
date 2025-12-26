FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    clang \
    lld \
    make \
    nasm \
    binutils \
    wget \
    curl \
    git \
    xorriso \
    qemu-system-x86 \
  && rm -rf /var/lib/apt/lists/*

RUN echo '#!/bin/sh\nexec clang --target=x86_64-unknown-none-elf "$@"' > /usr/local/bin/x86_64-elf-gcc \
  && chmod +x /usr/local/bin/x86_64-elf-gcc

RUN echo '#!/bin/sh\nexec ld.lld "$@"' > /usr/local/bin/x86_64-elf-ld \
  && chmod +x /usr/local/bin/x86_64-elf-ld

WORKDIR /work

CMD ["/bin/bash"]
