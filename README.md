# APK verifier
Solidity verifier implementation for [accountable light client](https://github.com/w3f/apk-proofs). This project is [funded by the web3 foundation](https://github.com/w3f/Grants-Program/blob/master/applications/solidity-verifier-for-accountable-light-client.md).
<img src="assets/w3f_grant_badge.png"  style="max-width: 100%; height: auto;">

## Overview
This repo holds two scheme apk verifier and associated libs:
- [Basic scheme verifier](./src/Basic.sol)
- [Packed scheme verifier](./src/Packed.sol)
- Libs
  * [BLS12-377](./src/common/bls12377)
  * [BW6-761](./src/common/bw6761)
  * [bytes](./src/common/bytes)
  * [math](./src/common/math)
  * [pcs](./src/common/pcs)
  * [piop](./src/common/piop)
  * [transcript](./src/common/transcipt)
  * [bitmask](./src/common/Bitmask.sol)

## Documentation
### Usage
To install with [**Foundry**](https://github.com/foundry-rs/foundry):
```sh
forge install darwinia-network/apk-verifier
```

### Install 
To install dependencies and compile contracts:
```sh
git clone --recurse-submodules https://github.com/darwinia-network/apk-verifier.git && cd apk-verifier
make tools
make
```
See inline code docs in the [book](https://darwinia-network.github.io/apk-verifier/)

## Testing and Testing Guide
1. Install [Rust](https://www.rust-lang.org/tools/install).
```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
2. Install [Foundry](https://github.com/foundry-rs/foundry).
```sh
curl -L https://foundry.paradigm.xyz | bash
```
3. Build [Darwinia Node](https://github.com/darwinia-network/darwinia/tree/apk-verifier).
```sh
git clone https://github.com/darwinia-network/darwinia.git --branch apk-verifier
cargo build --release -p darwinia --features pangolin-native
```
4. Run darwinia node.
```sh
./target/release/darwinia --chain pangolin-dev --alice --tmp --rpc-external --rpc-cors all --execution=native
```
5. Deploy basic/packed contract to local darwinia node.
```sh
make deploy-basic
make deploy-packed
```
6. Contract deployed at last transaction hash.
7. Run test script.
```sh
make test-basic  ADDR=0x3ed62137c5DB927cb137c26455969116BF0c23Cb
make test-packed ADDR=0xeAB4eEBa1FF8504c124D031F6844AD98d07C318f
```
8. Seeing the following results indicates that the test was successful.
```sh
0x0000000000000000000000000000000000000000000000000000000000000001
```

## Run Test in Docker

### 1. Run darwinia dev node

```
local% docker run -it --name my_container ghcr.io/darwinia-network/apk-verifier:v0.1.1 "./bin/darwinia --chain pangolin-dev --alice --tmp --rpc-external --rpc-cors all --execution=native"
```

### 2. Deploy test contracts

Enter the running `my_container`:

```
local% docker exec -it my_container bash
```

In `my_container`:

```
root@097f7b4f10da:/usr/src/app# make deploy-basic
root@097f7b4f10da:/usr/src/app# make deploy-packed
```

### 3. Run test

In `my_container`:

```
root@097f7b4f10da:/usr/src/app# make test-basic  ADDR=0x3ed62137c5DB927cb137c26455969116BF0c23Cb
root@097f7b4f10da:/usr/src/app# make test-packed ADDR=0xeAB4eEBa1FF8504c124D031F6844AD98d07C318f
```

Seeing the following results indicates that the test was successful:

```
0x0000000000000000000000000000000000000000000000000000000000000001
```

## License

Apache License v2.0
