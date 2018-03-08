import ether from "./helpers/ether";
import EVMRevert from "./helpers/EVMRevert";

const BigNumber = web3.BigNumber;

const should = require("chai")
  .use(require("chai-as-promised"))
  .use(require("chai-bignumber")(BigNumber))
  .should();

let TestToken = artifacts.require("./TestToken.sol");

contract("Token", accounts => {
  const owner = accounts[0];
  const spender = accounts[1];
  const destination = accounts[1];
  const value = ether(2);
  var token;

  beforeEach(async () => {
    token = await TestToken.new({ from: owner });
    // total supply is one billion tokens, using the ether helper here because decimals is 18
    const totalSupply = ether(100000000);
  });

  it("can be transferred when transfer", async () => {
    assert.ok(token);
    await token.transfer(destination, value, { from: owner });
    var destinationBalance = await token.balanceOf(destination);
    destinationBalance.should.be.deep.equal(new BigNumber(value));
  });

  xit("cannot be transferred when its not minted", async () => { 
  });

  xit("cannot be minted automatically until owner approves", async () => { 
  });

  xit("cannot be minted by owner after approval", async () => { 
  });

});
