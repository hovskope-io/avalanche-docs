---
sidebar_position: 13
---

# Keystore API

:::warning
Because the node operator has access to your plaintext password, you should only create a keystore user on a node that you operate. If that node is breached, you could lose all your tokens. Keystore APIs are not recommended for use on Mainnet.
:::

Every node has a built-in keystore. Clients create users on the keystore, which act as identities to be used when interacting with blockchains. A keystore exists at the node level, so if you create a user on a node it exists _only_ on that node. However, users may be imported and exported using this API.

For validation and cross-chain transfer on the Mainnet, you should issue transactions through [AvalancheJS](../../avalanchejs/README.md). That way control keys for your funds won't be stored on the node, which significantly lowers the risk should a computer running a node be compromised. See following docs for details:

- [Transfer AVAX Tokens Between Chains](../../../quickstart/cross-chain-transfers.md)
- [Add a Node to the Validator Set](../../../nodes/validate/add-a-validator.md)

:::info

This API set is for a specific node, it is unavailable on the [public server](../public-api-server.md).

:::

## Format

This API uses the `json 2.0` API format. For more information on making JSON RPC calls, see [here](issuing-api-calls.md).

## Endpoint

```text
/ext/keystore
```

## Methods

### keystore.createUser

Create a new user with the specified username and password.

#### **Signature**

```sh
keystore.createUser(
    {
        username:string,
        password:string
    }
) -> {}
```

- `username` and `password` can be at most 1024 characters.
- Your request will be rejected if `password` is too weak. `password` should be at least 8 characters and contain upper and lower case letters as well as numbers and symbols.

#### **Example Call**

```sh
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"keystore.createUser",
    "params" :{
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/keystore
```

#### **Example Response**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {}
}
```

### keystore.deleteUser

Delete a user.

#### **Signature**

```sh
keystore.deleteUser({username: string, password:string}) -> {}
```

#### **Example Call**

```sh
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"keystore.deleteUser",
    "params" : {
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/keystore
```

#### **Example Response**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {}
}
```

### keystore.exportUser

Export a user. The user can be imported to another node with [`keystore.importUser`](keystore.md#keystoreimportuser). The user’s password remains encrypted.

#### **Signature**

```sh
keystore.exportUser(
    {
        username:string,
        password:string,
        encoding:string //optional
    }
) -> {
    user:string,
    encoding:string
}
```

`encoding` specifies the format of the string encoding user data. Can only be `hex` when a value is provided.

#### **Example Call**

```sh
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"keystore.exportUser",
    "params" :{
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/keystore
```

#### **Example Response**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "user": "7655a29df6fc2747b0874e1148b423b954a25fcdb1f170d0ec8eb196430f7001942ce55b02a83b1faf50a674b1e55bfc00000000",
    "encoding": "hex"
  }
}
```

### keystore.importUser

Import a user. `password` must match the user’s password. `username` doesn’t have to match the username `user` had when it was exported.

#### **Signature**

```sh
keystore.importUser(
    {
        username:string,
        password:string,
        user:string,
        encoding:string //optional
    }
) -> {}
```

`encoding` specifies the format of the string encoding user data. Can only be `hex` when a value is provided.

#### **Example Call**

```sh
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"keystore.importUser",
    "params" :{
        "username":"myUsername",
        "password":"myPassword",
        "user"    :"0x7655a29df6fc2747b0874e1148b423b954a25fcdb1f170d0ec8eb196430f7001942ce55b02a83b1faf50a674b1e55bfc000000008cf2d869"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/keystore
```

#### **Example Response**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {}
}
```

### keystore.listUsers

List the users in this keystore.

#### **Signature**

```sh
keystore.ListUsers() -> {users:[]string}
```

#### **Example Call**

```sh
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"keystore.listUsers"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/keystore
```

#### **Example Response**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "users": ["myUsername"]
  }
}
```
