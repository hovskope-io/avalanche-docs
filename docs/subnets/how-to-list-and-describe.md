# How to View Your Created Subnets

## List Subnet Configurations

You can list the Subnets you've created with

`avalanche subnet list`

Example:

```text
> avalanche subnet list
+----------+-----------+------------+-----------+-----------+-------+----------+---------+
|  SUBNET  |   CHAIN   |  CHAIN ID  |   TYPE    | FROM REPO |       | DEPLOYED |         |
+----------+-----------+------------+-----------+-----------+-------+----------+---------+
|          |           |            |           |           | Local | Fuji     | Mainnet |
+----------+-----------+------------+-----------+-----------+-------+----------+---------+
| mySubnet | mySubnet  |       1000 | SubnetEVM | false     | No    | No       | No      |
+----------+-----------+------------+-----------+-----------+-------+----------+---------+
```

## Describe Subnet Configurations

To see the details of a specific configuration, run

`avalanche subnet describe <subnetName>`

Example:

```text
> avalanche subnet describe firstsubnet

 _____       _        _ _
|  __ \     | |      (_) |
| |  | | ___| |_ __ _ _| |___
| |  | |/ _ \ __/ _  | | / __|
| |__| |  __/ || (_| | | \__ \
|_____/ \___|\__\__,_|_|_|___/
+-------------+-------------+
|  PARAMETER  |    VALUE    |
+-------------+-------------+
| Subnet Name | firstsubnet |
+-------------+-------------+
| ChainId     | 12345       |
+-------------+-------------+
| Token Name  | FSN         |
+-------------+-------------+

  _____              _____             __ _
 / ____|            / ____|           / _(_)
| |  __  __ _ ___  | |     ___  _ __ | |_ _  __ _
| | |_ |/ _  / __| | |    / _ \| '_ \|  _| |/ _  |
| |__| | (_| \__ \ | |___| (_) | | | | | | | (_| |
 \_____|\__,_|___/  \_____\___/|_| |_|_| |_|\__, |
                                             __/ |
                                            |___/
+--------------------------+-------------+
|      GAS PARAMETER       |    VALUE    |
+--------------------------+-------------+
| GasLimit                 |     8000000 |
+--------------------------+-------------+
| MinBaseFee               | 25000000000 |
+--------------------------+-------------+
| TargetGas                |    15000000 |
+--------------------------+-------------+
| BaseFeeChangeDenominator |          36 |
+--------------------------+-------------+
| MinBlockGasCost          |           0 |
+--------------------------+-------------+
| MaxBlockGasCost          |     1000000 |
+--------------------------+-------------+
| TargetBlockRate          |           2 |
+--------------------------+-------------+
| BlockGasCostStep         |      200000 |
+--------------------------+-------------+

          _         _
    /\   (_)       | |
   /  \   _ _ __ __| |_ __ ___  _ __
  / /\ \ | | '__/ _  | '__/ _ \| '_ \
 / ____ \| | | | (_| | | | (_) | |_) |
/_/    \_\_|_|  \__,_|_|  \___/| .__/
                               | |
                               |_|
+--------------------------------------------+------------------------+---------------------------+
|                  ADDRESS                   | AIRDROP AMOUNT (10^18) |   AIRDROP AMOUNT (WEI)    |
+--------------------------------------------+------------------------+---------------------------+
| 0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC |                1000000 | 1000000000000000000000000 |
+--------------------------------------------+------------------------+---------------------------+


  _____                                    _ _
 |  __ \                                  (_) |
 | |__) | __ ___  ___ ___  _ __ ___  _ __  _| | ___  ___
 |  ___/ '__/ _ \/ __/ _ \| '_   _ \| '_ \| | |/ _ \/ __|
 | |   | | |  __/ (_| (_) | | | | | | |_) | | |  __/\__ \
 |_|   |_|  \___|\___\___/|_| |_| |_| .__/|_|_|\___||___/
                                    | |
                                    |_|

No precompiles set
```

### Viewing a Genesis File

If you'd like to see the raw genesis file, supply the `--genesis` flag to the describe command:

`avalanche subnet describe <subnetName> --genesis`

Example:

```text
> avalanche subnet describe firstsubnet --genesis
{
    "config": {
        "chainId": 12345,
        "homesteadBlock": 0,
        "eip150Block": 0,
        "eip150Hash": "0x2086799aeebeae135c246c65021c82b4e15a2c451340993aacfd2751886514f0",
        "eip155Block": 0,
        "eip158Block": 0,
        "byzantiumBlock": 0,
        "constantinopleBlock": 0,
        "petersburgBlock": 0,
        "istanbulBlock": 0,
        "muirGlacierBlock": 0,
        "subnetEVMTimestamp": 0,
        "feeConfig": {
            "gasLimit": 8000000,
            "targetBlockRate": 2,
            "minBaseFee": 25000000000,
            "targetGas": 15000000,
            "baseFeeChangeDenominator": 36,
            "minBlockGasCost": 0,
            "maxBlockGasCost": 1000000,
            "blockGasCostStep": 200000
        },
        "contractDeployerAllowListConfig": {
            "blockTimestamp": null,
            "adminAddresses": null
        },
        "contractNativeMinterConfig": {
            "blockTimestamp": null,
            "adminAddresses": null
        },
        "txAllowListConfig": {
            "blockTimestamp": null,
            "adminAddresses": null
        }
    },
    "nonce": "0x0",
    "timestamp": "0x0",
    "extraData": "0x",
    "gasLimit": "0x7a1200",
    "difficulty": "0x0",
    "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "coinbase": "0x0000000000000000000000000000000000000000",
    "alloc": {
        "8db97c7cece249c2b98bdc0226cc4c2a57bf52fc": {
            "balance": "0xd3c21bcecceda1000000"
        }
    },
    "airdropHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "airdropAmount": null,
    "number": "0x0",
    "gasUsed": "0x0",
    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "baseFeePerGas": null
}
```
