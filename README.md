# fr8-token
Smart Contracts for our token. Will be made public some time soon.


# TestToken
## How to use

### testing  
  
```
yarn

yarn run test

```

  
### running on rinkeby or mainnet
1. `cp .env.example .env`
2. get 12 word seed from metamask 
3. register with Infura and put API key in .env
4. `truffle migrate --network rinkeby --compile-all --reset`

