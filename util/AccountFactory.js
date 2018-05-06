require('babel-register');
require('babel-polyfill');

const uuidv4 = require('uuid/v4');
const Accounts = require('web3-eth-accounts');


var AccountFactory = function(options) {
  const { connection, network } = options;
  console.log('connection:',connection);
  this.connection = connection;
  this.network = network;

  // todo make builder logic dependent on network
  this.builder = new Accounts(connection);

}


AccountFactory.prototype.build = function (entropy) {
  return this.builder.create(entropy)
}

module.exports = AccountFactory
