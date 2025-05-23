# Banff Changes

This document specifies the changes in Avalanche “Banff”, which will be released in AvalancheGo v1.9.x.

## Block Changes

### Apricot

Apricot allows the following block types with the following content:

- _Standard Blocks_ may contain multiple transactions of the following types:
  - CreateChainTx
  - CreateSubnetTx
  - ImportTx
  - ExportTx
- _Proposal Blocks_ may contain a single transaction of the following types:
  - AddValidatorTx
  - AddDelegatorTx
  - AddSubnetValidatorTx
  - RewardValidatorTx
  - AdvanceTimeTx
- _Options Blocks_, i.e. _Commit Block_ and _Abort Block_ do not contain any transactions.

Each block has a header containing:

- ParentID
- Height

### Banff

Banff allows the following block types with the following content:

- _Standard Blocks_ may contain multiple transactions of the following types:
  - CreateChainTx
  - CreateSubnetTx
  - ImportTx
  - ExportTx
  - AddValidatorTx
  - AddDelegatorTx
  - AddSubnetValidatorTx
  - _RemoveSubnetValidatorTx_
  - _TransformSubnetTx_
  - _AddPermissionlessValidatorTx_
  - _AddPermissionlessDelegatorTx_
- _Proposal Blocks_ may contain a single transaction of the following types:

  - RewardValidatorTx

- _Options blocks_, i.e. _Commit Block_ and _Abort Block_ do not contain any transactions.

Note that each block has an header containing:

- ParentID
- Height
- _Time_

So the two main differences with respect to Apricot are:

- _AddValidatorTx_, _AddDelegatorTx_, _AddSubnetValidatorTx_ are included into Standard Blocks rather than Proposal Blocks so that they don't need to be voted on (i.e. followed by a Commit/Abort Block).
- New Transaction types: _RemoveSubnetValidatorTx_, _TransformSubnetTx_, _AddPermissionlessValidatorTx_, and _AddPermissionlessDelegatorTx_ have been added into Standard Blocks.
- Block timestamp is explicitly serialized into block header, to allow chain time update.

### New Transactions

#### RemoveSubnetValidatorTx

```go
type RemoveSubnetValidatorTx struct {
	BaseTx `serialize:"true"`
	// The node to remove from the subnet.
	NodeID ids.NodeID `serialize:"true" json:"nodeID"`
	// The subnet to remove the node from.
	Subnet ids.ID `serialize:"true" json:"subnet"`
	// Proves that the issuer has the right to remove the node from the subnet.
	SubnetAuth verify.Verifiable `serialize:"true" json:"subnetAuthorization"`
}
```

#### TransformSubnetTx

```go
type TransformSubnetTx struct {
	// Metadata, inputs and outputs
	BaseTx `serialize:"true"`
	// ID of the Subnet to transform
	// Restrictions:
	// - Must not be the Primary Network ID
	Subnet ids.ID `serialize:"true" json:"subnetID"`
	// Asset to use when staking on the Subnet
	// Restrictions:
	// - Must not be the Empty ID
	// - Must not be the AVAX ID
	AssetID ids.ID `serialize:"true" json:"assetID"`
	// Amount to initially specify as the current supply
	// Restrictions:
	// - Must be > 0
	InitialSupply uint64 `serialize:"true" json:"initialSupply"`
	// Amount to specify as the maximum token supply
	// Restrictions:
	// - Must be >= [InitialSupply]
	MaximumSupply uint64 `serialize:"true" json:"maximumSupply"`
	// MinConsumptionRate is the rate to allocate funds if the validator's stake
	// duration is 0
	MinConsumptionRate uint64 `serialize:"true" json:"minConsumptionRate"`
	// MaxConsumptionRate is the rate to allocate funds if the validator's stake
	// duration is equal to the minting period
	// Restrictions:
	// - Must be >= [MinConsumptionRate]
	// - Must be <= [reward.PercentDenominator]
	MaxConsumptionRate uint64 `serialize:"true" json:"maxConsumptionRate"`
	// MinValidatorStake is the minimum amount of funds required to become a
	// validator.
	// Restrictions:
	// - Must be > 0
	// - Must be <= [InitialSupply]
	MinValidatorStake uint64 `serialize:"true" json:"minValidatorStake"`
	// MaxValidatorStake is the maximum amount of funds a single validator can
	// be allocated, including delegated funds.
	// Restrictions:
	// - Must be >= [MinValidatorStake]
	// - Must be <= [MaximumSupply]
	MaxValidatorStake uint64 `serialize:"true" json:"maxValidatorStake"`
	// MinStakeDuration is the minimum number of seconds a staker can stake for.
	// Restrictions:
	// - Must be > 0
	MinStakeDuration uint32 `serialize:"true" json:"minStakeDuration"`
	// MaxStakeDuration is the maximum number of seconds a staker can stake for.
	// Restrictions:
	// - Must be >= [MinStakeDuration]
	// - Must be <= [GlobalMaxStakeDuration]
	MaxStakeDuration uint32 `serialize:"true" json:"maxStakeDuration"`
	// MinDelegationFee is the minimum percentage a validator must charge a
	// delegator for delegating.
	// Restrictions:
	// - Must be <= [reward.PercentDenominator]
	MinDelegationFee uint32 `serialize:"true" json:"minDelegationFee"`
	// MinDelegatorStake is the minimum amount of funds required to become a
	// delegator.
	// Restrictions:
	// - Must be > 0
	MinDelegatorStake uint64 `serialize:"true" json:"minDelegatorStake"`
	// MaxValidatorWeightFactor is the factor which calculates the maximum
	// amount of delegation a validator can receive.
	// Note: a value of 1 effectively disables delegation.
	// Restrictions:
	// - Must be > 0
	MaxValidatorWeightFactor byte `serialize:"true" json:"maxValidatorWeightFactor"`
	// UptimeRequirement is the minimum percentage a validator must be online
	// and responsive to receive a reward.
	// Restrictions:
	// - Must be <= [reward.PercentDenominator]
	UptimeRequirement uint32 `serialize:"true" json:"uptimeRequirement"`
	// Authorizes this transformation
	SubnetAuth verify.Verifiable `serialize:"true" json:"subnetAuthorization"`
}
```

#### AddPermissionlessValidatorTx

```go
type AddPermissionlessValidatorTx struct {
	// Metadata, inputs and outputs
	BaseTx `serialize:"true"`
	// Describes the validator
	Validator validator.Validator `serialize:"true" json:"validator"`
	// ID of the subnet this validator is validating
	Subnet ids.ID `serialize:"true" json:"subnet"`
	// Where to send staked tokens when done validating
	StakeOuts []*avax.TransferableOutput `serialize:"true" json:"stake"`
	// Where to send validation rewards when done validating
	ValidatorRewardsOwner fx.Owner `serialize:"true" json:"validationRewardsOwner"`
	// Where to send delegation rewards when done validating
	DelegatorRewardsOwner fx.Owner `serialize:"true" json:"delegationRewardsOwner"`
	// Fee this validator charges delegators as a percentage, times 10,000
	// For example, if this validator has DelegationShares=300,000 then they
	// take 30% of rewards from delegators
	DelegationShares uint32 `serialize:"true" json:"shares"`
}
```

#### AddPermissionlessDelegatorTx

```go
type AddPermissionlessDelegatorTx struct {
	// Metadata, inputs and outputs
	BaseTx `serialize:"true"`
	// Describes the validator
	Validator validator.Validator `serialize:"true" json:"validator"`
	// ID of the subnet this validator is validating
	Subnet ids.ID `serialize:"true" json:"subnet"`
	// Where to send staked tokens when done validating
	Stake []*avax.TransferableOutput `serialize:"true" json:"stake"`
	// Where to send staking rewards when done validating
	RewardsOwner fx.Owner `serialize:"true" json:"rewardsOwner"`
}
```

#### New TypeIDs

```go
ApricotProposalBlock = 0
ApricotAbortBlock = 1
ApricotCommitBlock = 2
ApricotStandardBlock = 3
ApricotAtomicBlock = 4

secp256k1fx.TransferInput = 5
secp256k1fx.MintOutput = 6
secp256k1fx.TransferOutput = 7
secp256k1fx.MintOperation = 8
secp256k1fx.Credential = 9
secp256k1fx.Input = 10
secp256k1fx.OutputOwners = 11

AddValidatorTx = 12
AddSubnetValidatorTx = 13
AddDelegatorTx = 14
CreateChainTx = 15
CreateSubnetTx = 16
ImportTx = 17
ExportTx = 18
AdvanceTimeTx = 19
RewardValidatorTx = 20

stakeable.LockIn = 21
stakeable.LockOut = 22

RemoveSubnetValidatorTx = 23
TransformSubnetTx = 24
AddPermissionlessValidatorTx = 25
AddPermissionlessDelegatorTx = 26

EmptyProofOfPossession = 27
BLSProofOfPossession   = 28

BanffProposalBlock = 29
BanffAbortBlock = 30
BanffCommitBlock = 31
BanffStandardBlock = 32
```
