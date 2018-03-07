'use strict';

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _TokenSale = require('../tauren/TokenSale');

var _TokenSale2 = _interopRequireDefault(_TokenSale);

var _web = require('web3');

var _web2 = _interopRequireDefault(_web);

var _fs = require('fs');

var _fs2 = _interopRequireDefault(_fs);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

require('babel-register');
require('babel-polyfill');

var dir = __dirname;
var TokenSaleSourceMap = _fs2.default.readFileSync(dir + '/../build/contracts/TokenSale.json', 'utf8');
var TokenSaleSource = JSON.parse(TokenSaleSourceMap);
var abi = TokenSaleSource.abi;

var web3 = new _web2.default(new _web2.default.providers.HttpProvider("http://localhost:8545"));
var address = '0x5c2513a6be59f3ec4dad39caea4bec67fbb77571'; //deployed address on testnet
var config = { web3: web3, abi: abi, address: address };
var tokenSale = new _TokenSale2.default(_extends({}, config));

tokenSale.sayHello();
tokenSale.addToWhitelist(getAccounts());
tokenSale.getWhitelist(getAccounts()[0]);

function getAccounts() {
  return ["0x81Edfbcc12Abb98A3660608Dd1B65105EF2F00E5", "0xa55E06E3C33D8e8d0AA654fB9b549dEC7D25F48A", "0xF3d43ce61Af1Bf1A0fF6741c96A0A6D1c61Bf0eb", "0x4e624BFb4594A8d93F8c44E52923c892D46dA194", "0x1Bfb63a4674Fb8002d1Ad04D7869A2bFc668fa68", "0x38d31a5C839fDcf1202FbB3a1347b4fea35c694D", "0x2cf84e962CF547c81b215bc8E0310846b661622d", "0x53e50202EB8D696bd1Ec96B0D8E9366E4D39b73A", "0xfDD788fe153422Cc0f58D73Bd7a309dC8eBD0106", "0xf2240a8AD2227Cf53E19EF4683B02C9f1d57E192", "0xfDA1CB989bA8846F9C0316459AfB134eDb40a7eC", "0x5f8568aD07413Eb409247eE2A31C33c0ce82f19d", "0x4534E0AA80e79178726C08425bDBEAE0C105192D", "0x4fca18B6c98012069Acda0452916F7191C64454f", "0x7C5459E100Efa55a7C62eFb4C850046eE300847f", "0xF43CfE143CBb2019d47848B38faeD25645dab1a8", "0x8ea3Ab594f8E920DF45D074e88BC4eC1b6De7Fb6", "0xae88907C9Ef739076Cc68E44376Dc0aD0E3Dd57F", "0x9c378eEd63eEe79D84903A5bBEB593273F05F2DA", "0x23e6C3f5eC4cAbEf2e8402B7B169757125c2D320"];
}