require('babel-register');
require('babel-polyfill');
import TokenSale from '../tauren/TokenSale';
import Web3  from 'web3';
import fs from 'fs';
const myJson = fs.readFileSync('~/stowit/stow-it-token/build/contracts/TokenSale.json');

console.log('myJson:',myJson);
console.log('foo');
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
console.log('web3:',web3);
const tokenSale = new TokenSale({})
console.log('tokenSale:',tokenSale);
tokenSale.sayHello();