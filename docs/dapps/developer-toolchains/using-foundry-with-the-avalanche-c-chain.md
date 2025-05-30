# Using Foundry with the Avalanche C-Chain

## Introduction

This guide shows how to deploy and interact with smart contracts using foundry on on a local Avalanche Network and the [Fuji C-Chain](../../quickstart/fuji-workflow.md), which is an instance of the EVM.

[Foundry toolchain](https://github.com/foundry-rs/foundry) is a smart contract development toolchain written in Rust. It manages your dependencies, compiles your project, runs tests, deploys, and lets you interact with the chain from the command-line.

## Recommended Knowledge

- Basic understanding of [Solidity](https://docs.soliditylang.org) and Avalanche.
- You are familiar with [Avalanche Smart Contract Quickstart](https://github.com/ava-labs/avalanche-smart-contract-quickstart).
- Basic understanding of the [Avalanche's architecture](../../overview/getting-started/avalanche-platform.md)
- performed a cross-chain swap via this [this tutorial](https://support.avax.network/en/articles/6169872-how-to-make-a-cross-chain-transfer-in-the-avalanche-wallet) to get funds to your C-Chain address.

## Requirements

- You have [installed Foundry](https://github.com/foundry-rs/foundry#installation). This installation includes the `forge` and `cast` binaries used in this walk-through.

### AvalancheGo and Avalanche Network Runner

[AvalancheGo](https://github.com/ava-labs/avalanchego) is an Avalanche node implementation written in Go. 

[Avalanche Network Runner](../../subnets/network-runner.md) is a tool to quickly deploy local test networks. Together, you can deploy local test networks and run tests on them.

Start a local five node Avalanche network:

```zsh
cd /path/to/avalanche-network-runner
# start a five node staking network
./go run examples/local/fivenodenetwork/main.go
```

A five node Avalanche network is running on your machine. Network will run until you CTRL + C to exit.

## Getting Started

This section will walk you through creating an [ERC721](https://eips.ethereum.org/EIPS/eip-721).

### Clone Avalanche Smart Contract Quick Start

Clone the [quickstart repository](https://github.com/ava-labs/avalanche-smart-contract-quickstart) and install the necessary packages via `yarn`.

```zsh
git clone https://github.com/ava-labs/avalanche-smart-contract-quickstart.git
cd avalanche-smart-contract-quickstart
yarn
```

In order to deploy contracts, you need to have some AVAX. You can get testnet AVAX from the [Avalanche Faucet](https://faucet.avax.network), which is an easy way to get to play around with Avalanche. After getting comfortable with your code, you can run it on Mainnet after making the necessary changes to your workflow.

## Write Contracts

We will use our example ERC721 smart contract, [`NFT.sol`](https://github.com/ava-labs/avalanche-smart-contract-quickstart/blob/3fbba0ac28f6420e9be5d2635d5f23693f80127a/contracts/NFT.sol) found in `./contracts` of our project.

```ts
//SPDX-License-Identifier: MIT
// contracts/ERC721.sol

pragma solidity >=0.6.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721 {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("GameItem", "ITM") {}

  // commented out unused variable
  // function awardItem(address player, string memory tokenURI)
  function awardItem(address player)
    public
    returns (uint256)
  {
    _tokenIds.increment();

    uint256 newItemId = _tokenIds.current();
    _mint(player, newItemId);
    // _setTokenURI(newItemId, tokenURI);

    return newItemId;
  }
}
```

Let's examine this implementation of an NFT as a Game Item. We start by importing to contracts from our node modules. We import Openzeppelin's open source implementation of the [ERC721 standard](https://docs.openzeppelin.com/contracts/2.x/api/token/erc721) which our NFT contract will inherit from. Our constructor takes the `_name` and `_symbol` arguments for our NFT and passes them on to the constructor of the parent ERC721 implementation. Lastly we implement the `awardItem` function which allows anyone to mint an NFT to a player's wallet address. This function increments the `currentTokenId` and makes use of the `_mint` function of our parent contract.

## Compile & deploy with Forge

[Forge](https://book.getfoundry.sh/reference/forge/forge-build.html) is a command-line tool that ships with Foundry. Forge tests, builds, and deploys your smart contracts.

To compile the NFT contract run:

```zsh
forge build
```

By default the compiler output will be in the `out` directory. To deploy our compiled contract with Forge we have to set environment variables for the RPC endpoint and the private key we want to use to deploy.

Set your environment variables by running:

```zsh
export RPC_URL=<YOUR-RPC-ENDPOINT>
export PRIVATE_KEY=<YOUR-PRIVATE-KEY>
```

Since we are deploying to Fuji testnet, our `RPC_URL` export should be:

```zsh
export RPC_URL=https://api.avax-test.network/ext/bc/C/rpc
```

Once set, you can [deploy your NFT with Forge](https://book.getfoundry.sh/reference/forge/forge-create.html) by running the command below while adding the values for `_name` and `_symbol`, the relevant [constructor arguments](https://github.com/ava-labs/avalanche-smart-contract-quickstart/blob/3ad93abf50fba65e3aab68f23382bcace73968be/contracts/NFT.sol#L13) of the NFT contract:

```zsh
forge create NFT --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --constructor-args GameItem ITM
```

Upon successful deployment, you will see the deploying wallet's address, the contract's address as well as the transaction hash printed to your terminal.

Here's an example output from an NFT deployment.

```zsh
[⠔] Compiling...
No files changed, compilation skipped
Deployer: 0x8db97c7cece249c2b98bdc0226cc4c2a57bf52fc
Deployed to: 0x52c84043cd9c865236f11d9fc9f56aa003c1f922
Transaction hash: 0xf35c40dbbdc9e4298698ad1cb9937195e5a5e74e557bab1970a5dfd42a32f533
```

_Note: Please store your `Deployed to` address for use in the next section._

## Using Cast to Interact with the Smart Contract

We can call functions on our NFT contract with [Cast](https://book.getfoundry.sh/reference/cast/cast-send.html), Foundry's command-line tool for interacting with smart contracts, sending transactions, and getting chain data. In this scenario, we will mint a Game Item to a player's wallet using the [`awardItem` function](https://github.com/ava-labs/avalanche-smart-contract-quickstart/blob/0f29cbb6375a1a452579213f688609c880d52c01/contracts/NFT.sol#L17) in our smart contract.

Mint an NFT from your contract by replacing `<NFT-CONTRACT-ADDRESS>` with your `Deployed to` address and `<NFT-RECIPIENT-ADDRESS>` with an address of your choice.

_Note: This section assumes that you have already set your RPC and private key env variables during deployment_

```zsh
cast send --rpc-url=$RPC_URL  <NFT-CONTRACT-ADDRESS> "awardItem(address)" <NFT-RECIPIENT-ADDRESS> --private-key=$PRIVATE_KEY
```

Upon success, the command line will display the [transaction data](https://testnet.snowtrace.io/tx/0x4651ae041a481a6eeb852e5300e9be48e66a1d2332733df22d8e75cf460b0c2c).

```zsh
blockHash               0x1d9b0364fe002eeddd0e32be0c27d6797c63dffb51fe555ea446357759e6a6f8
blockNumber             10714448
contractAddress
cumulativeGasUsed       90837
effectiveGasPrice       28000000000
gasUsed                 90837
logs                    [{"address":"0x45857b942723fff8ee7acd2b1d6515d9965c16e5","topics":["0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef","0x0000000000000000000000000000000000000000000000000000000000000000","0x000000000000000000000000845095a03a6686e24b90fed55e11f4ec808b1ab3","0x0000000000000000000000000000000000000000000000000000000000000001"],"data":"0x","blockHash":"0x1d9b0364fe002eeddd0e32be0c27d6797c63dffb51fe555ea446357759e6a6f8","blockNumber":"0xa37d50","transactionHash":"0x4651ae041a481a6eeb852e5300e9be48e66a1d2332733df22d8e75cf460b0c2c","transactionIndex":"0x0","logIndex":"0x0","removed":false}]
logsBloom               0x00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000040000000000000000000000000008010000000000000000040000000000000000000000000000020000040000000000000800000000002000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000060080000000000000000000000000000000000000000000000000000000000000000
root
status                  1
transactionHash         0x4651ae041a481a6eeb852e5300e9be48e66a1d2332733df22d8e75cf460b0c2c
transactionIndex        0
type                    2
```

Well done! You just minted your first NFT from your contract. You can check the owner of `tokenId` 1 by running the `cast call` command below:

```zsh
cast call --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY <NFT-CONTRACT-ADDRESS> "ownerOf(uint256)" 1
```

The address you provided above should be returned as the owner.

```zsh
0x000000000000000000000000845095a03a6686e24b90fed55e11f4ec808b1ab3
```

## Mainnet Workflow

The Fuji workflow above can be adapted to Mainnet with the following modifications to the environment variables:

```zsh
export RPC_URL=https://api.avax.network/ext/bc/C/rpc
export PRIVATE_KEY=<YOUR-PRIVATE-KEY>
```

## Local Workflow

The Fuji workflow above can be adapted to a Local Network by doing following:

In a new terminal navigate to your [Avalanche Network Runner](../../subnets/network-runner.md) directory.

```zsh
cd /path/to/Avalanche-Network-Runner
```

Next, deploy a new Avalanche Network with five nodes (a Cluster) locally.

```zsh
go run examples/local/fivenodenetwork/main.go
```

Next, modify the environment variables in your Foundry project:

```zsh
export RPC_URL=http://localhost:9650/ext/bc/C/rpc
export PRIVATE_KEY=56289e99c94b6912bfc12adc093c9b51124f0dc54ac7a766b2bc5ccf558d8027
```

:::warning
The example PRIVATE_KEY variable above provides a pre-funded account on Avalanche Network Runner and should be used for LOCAL DEVELOPMENT ONLY.
:::

## Summary

Now you have the tools you need to launch a local Avalanche network, create a Foundry project, as well as create, compile, deploy and interact with Solidity contracts.

Join our [Discord Server](https://chat.avax.network) to learn more and ask any questions you may have.