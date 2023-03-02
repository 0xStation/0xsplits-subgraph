# Station Protocol Subgraph

Station's subgraph is currently hosted by The Graph via a free service.
You can browse our subgraph [here](https://thegraph.com/hosted-service/subgraph/0xstation/station).

[Local Setup](#local-setup)
* [Requirements](#requirements)
* [Run local node](#run-local-node)
    - [0. Set environment](#0-set-environment)
    - [1. Run local IPFS node](#1-run-local-ipfs-node)
    - [2. Start local Postgres database](#2-start-local-postgres-database)
    - [3. Run local Graph node](#3-run-local-graph-node)
* [Deploy local subgraph](#deploy-local-subgraph)
    - [1. Refresh local build](#1-refresh-local-build)
    - [2. Deploy subgraph](#2-deploy-subgraph)
* [Query local subgraph](#query-local-subgraph)

[Hosted Service Deploy](#hosted-service-deploy)
* [Requirements](#requirements-1)
* [Hosted Service authentication](#hosted-service-authentication)
    - [1. Sign in to The Graph](#1-sign-in-to-the-graph)
    - [2. Authenticate from command line](#2-authenticate-from-command-line)
* [Deploy hosted subgraph](#deploy-hosted-subgraph)
    - [1. Refresh local build](#1-refresh-local-build-1)
    - [2. Deploy subgraph](#2-deploy-subgraph-1)

# Local Setup

Guide based on official Github docs [here](https://github.com/graphprotocol/graph-node#quick-start).

## Requirements

- Yarn (`yarn` CLI)
- Rust (`cargo` CLI)
- IPFS (`ipfs` CLI)
- Postgres (`psql` CLI)
- Graph (`graph` CLI)

## Run local node

### 0. Set environment

```
cp template.env .env
```

Fill in the fields:
- `ALCHEMY_API_KEY`: Station-wide key for Alchemy's node providers
- `USERNAME`: your local machine's username; used for connecting to postgres superuser

### 1. Run local IPFS node

First time setup only:

```
brew install ipfs
```

Start local daemon:

```
yarn ipfs
```

Note: running the ipfs daemon occupies the tab from now on; make a new tab to continue.

### 2. Start local Postgres database

First time setup only:

```
brew install postgres
createdb graph-node
```

Start local postgres process:

```
yarn run-postgres
```

### 3. Run local Graph node

First time setup only:

```
yarn lib
brew install rust
yarn build-graph-node
```

Start local Graph node:

```
yarn run-graph-node
```

Note: running the graph node occupies the tab from now on; make a new tab to continue.

## Deploy local subgraph

### 1. Refresh local build

First time setup only:

```
yarn global add @graphprotocol/graph-cli
```

Generate ABI, TS and WASM files from source:

```
yarn abi
yarn gen
yarn build
```

### 2. Deploy subgraph

First time setup only:

```
yarn create
```

Upload the schema, WASM, and ABI files to local ipfs node:

```
yarn deploy
```

## Query local subgraph

View the local GraphiQL interface at:
[http://localhost:8000/subgraphs/name/0xStation/Station/graphql](http://localhost:8000/subgraphs/name/0xStation/Station/graphql)

# Hosted Service Deploy

## Requirements

- Yarn (`yarn` CLI)
- Graph (`graph` CLI)
- Github account that is an admin of the `OxStation` organization

## Hosted Service authentication

### 1. Sign in to The Graph

Go to the [Hosted Service](https://thegraph.com/hosted-service) page on The Graph and login with your Github credentials.

Go to `My Dashboards` tab at the top of the app which will view your created and bookmarked subgraphs. Your profile on this page is clickable and you can switch to the 0xStation account. After switching accounts, you should be able to view the `Station` subgraph; open it and bookmark it for your own convenience.

Go back to the `My Dashboards` view within our organization account. To the right of the account details, there is an `Access token`; copy it for the next step.

### 2. Authenticate from command line

Configure your local `graph` CLI with this auth token using:

```
ACCESS_TOKEN=<paste-token> yarn auth
```

## Deploy hosted subgraph

### 1. Refresh local build

```
yarn gen
yarn build
```

### 2. Deploy subgraph

Now that your CLI is authenticated, you can redeploy to our public subgraph from your local source with:

```
yarn deploy-rinkeby
```
