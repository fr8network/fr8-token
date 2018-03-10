const TestToken = artifacts.require("./Fr8NetworkToken.sol");

module.exports = function(deployer, network, accounts) {
  setupContracts(deployer, accounts);
};

async function setupContracts(deployer, accounts) {
  const owner = accounts[0];
  // const owner = "0x11f0cdddd75259b02418e5c116d904621632a590";
  const token = await TestToken.deployed();
  const totalSupply = new web3.BigNumber(web3.toWei(100000000, "ether"));
}
