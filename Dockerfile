FROM rust:latest

RUN apt update && apt install -y curl protobuf-compiler clang
RUN curl -L https://foundry.paradigm.xyz | bash
RUN . /root/.bashrc && foundryup

WORKDIR /usr/src/app

COPY . .

ENTRYPOINT ["/bin/bash", "-c"]