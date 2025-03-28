# What's the Subnet Development Lifecycle?

As you begin your Subnet journey, it's useful to look at the lifecycle of taking a Subnet from idea
to production.

## Figure Out Your Needs

The first step of planning your Subnet is determining your applications needs. What features do you
need that the Avalanche C-Chain doesn't provide? Perhaps you want your own gas token or only want
to allow access to KYCed customers. [When to Build on a Subnet vs. on the C-Chain](./when-to-use-subnet-vs-c-chain.md)
can help you make the decision.

### Decide What Type of Subnet You Want

Once you've decided to use a Subnet, you need to decide what type of Subnet to build. This means
choosing a virtual machine (VM) to create your Subnet with. Broadly speaking, there are three types
of VMs to choose from:

#### EVM-Based Subnets

EVM-based Subnets are forks of the Avalanche C-Chain. They support Solidity
smart contracts and standard [Ethereum
APIs](/apis/avalanchego/apis/c-chain#ethereum-apis).
[Subnet-EVM](https://github.com/ava-labs/subnet-evm) is Ava Labs' implementation
of an EVM-Based Subnet.

Subnet-EVM is far and away the safest and most popular choice to build your Subnet with. It has the
most mature developer tooling and receives regular updates by the Ava Labs team.

#### Experimental Subnets

Experimental Subnets are proof-of-concept VMs developed by Ava Labs. They include the
[SpacesVM](spaces), [TimestampVM Go](create-a-vm-timestampvm), [TimestampVM
Rust](create-a-simple-rust-vm), [BlobVM](create-a-vm-blobvm), and others. These VMs are demo software
and aren't ready for production environments. Although they do receive periodic updates, the Ava
Labs team hasn't audited their performance and security, internally or externally. However, these
open source projects are intended to inspire the community, and provide novel capabilities not
available inside the EVM.

If you're looking to push the boundaries of what's possible with Subnets, this is a great place to
get started.

#### Custom Subnets

Custom Subnets are an open-ended interface that allow developers to build any VM they can dream.
These VMs may be a fork of an existing VM such as Subnet-EVM, SpacesVM, or even a
non-Avalanche-native VM such as Solana's virtual machine. Alternatively, you can build your VM
entirely from scratch using almost any programming language. See [Introduction to
VMs](introduction-to-vm) for advice on getting started.

### Determine Tokenomics

Subnets are powered by gas tokens. When you build a Subnet, you have the option to decide what token
you use and optionally, how you distribute it. You may use AVAX, an existing C-Chain token, or a
brand new token. You'll need to decide how much of the supply you want to use to reward validators,
what kind of emitting schedule you want, and how much to airdrop. Blocks may burn transaction fees
or give them to validators as a block reward.

### Decide how to Customize Your Subnet

After you've selected your VM, you may want to customize it. This may mean airdropping tokens to
your team in the genesis, setting how gas fees rates on your network, or changing the
behavior of your VM via precompiles. These customizations are hard to get right on paper and usually
require some trial and error to determine correctly. See [Customize Your EVM-Powered
Subnet](customize-a-subnet) for instructions on configuring Subnet-EVM.

## Learn Avalanche-CLI

Now that you've specified your Subnet requirements, the next step is learning Avalanche-CLI.

Avalanche-CLI is the best tool for rapidly prototyping Subnets and deploying them to production. You
can use it throughout the entire Subnet development lifecycle. To get started, take a look at [Build
Your First Subnet](build-first-subnet).

### Deploy Your Subnet Locally

The first stage of Subnet development involves testing your Subnet on your local machine or on a
private cloud server such as Amazon EC2. The goal of this phase is to lock-in your Subnet
customizations and create your full-stack dapp without the constraints of deploying on a public
network.

Development is extremely quick and updates take seconds to minutes to apply. In this phase,
you should restrict dapp access to trusted parties. Because you're interacting with a local copy of
the Avalanche network, you can't access production state or other production Subnets.

### Deploy Your Subnet to Fuji

The second stage of Subnet development involves deploying your Subnet and your dapp to the Fuji
Testnet. This phase tests your ability to run validator nodes, coordinate all parties involved in
the Subnet, and monitor network health. You can also practice using Ledgers to manage Subnet
transactions.

The Subnet is publicly visible and you may want to allow external users to test your
dapp. Development on Fuji is significantly slower than with local development. Updates may now take
hours to days to apply. It's important to do as much local testing as possible before moving to
Fuji.

### Deploy Your Subnet to Mainnet

The final stage of Subnet development is creating your Subnet on Mainnet and deploying your dapp.
It's time to let your real users in.

Once your Subnet is in production, you have little flexibility
to change it. Some alterations are possible, but they require days to weeks to implement and roll
out.

Your focus should shift to preserving network stability and upgrading your nodes as needed.

## Start Developing Custom VMs

If you've mastered Subnet-EVM and are looking for an additional challenge, consider building a
custom VM. The Avalanche network supports far more than just the EVM. Current VMs only scratch the
surface of what's possible.

Some ideas:

- Port an existing blockchain project to Avalanche. For example: Use Bitcoin's VM or Solana's VM.
- Create an app-specific VM instead of a general purpose VM. For example, create a DEX
  or a CLOB VM instead of something like the EVM.
- Create a more efficient implementation of the EVM.
