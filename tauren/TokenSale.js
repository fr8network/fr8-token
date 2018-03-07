function TokenSale(config) {
  const DEFAULT_GAS = 3300000;
  const { web3, abi, address, gas } = config;
  const orm = web3.eth.contract(abi);
  this.web3 = web3;
  this.abi = abi;;
  this.orm = orm;
  this.instance = orm.at(address)
  this.from = { from: web3.eth.accounts[0], gas: gas || DEFAULT_GAS }
}

TokenSale.prototype.addToWhitelist = function (addresses) {
  let _from = this.from;
  this.instance.addToWhitelist(addresses, _from)
}

TokenSale.prototype.getWhitelist = function (address) {
  let f = this.instance.whitelist.call(address);
}

TokenSale.prototype.sayHello = function () {
  console.log('this.instance:',this.instance);
}

module.exports = TokenSale;


