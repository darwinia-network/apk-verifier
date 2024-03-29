FROM rust:latest

WORKDIR /usr/src/app
COPY . .

RUN apt update && apt install -y curl protobuf-compiler clang

# foundry
RUN curl -L https://foundry.paradigm.xyz | bash
RUN . /root/.bashrc && foundryup

# darwinia dev node for apk-verifier
RUN git clone https://github.com/darwinia-network/darwinia.git --branch apk-verifier --depth 1
RUN cd darwinia && \
    cargo build --release -p darwinia --features pangolin-native && \
    cp ./target/release/darwinia ./../bin/ && \
    cd .. && rm -rf darwinia

RUN git submodule update --init --recursive

ENTRYPOINT ["/bin/bash", "-c"]
