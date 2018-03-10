import ether from "./helpers/ether";
import EVMRevert from "./helpers/EVMRevert";

const BigNumber = web3.BigNumber;

const should = require("chai")
  .use(require("chai-as-promised"))
  .use(require("chai-bignumber")(BigNumber))
  .should();

let TestToken = artifacts.require("./TestToken.sol");


// Wraps CB Function in a Promise
function promisify(inner) {
  return new Promise((resolve, reject) =>
    inner((err, res) => {
      if (err) return reject(err);
      else return resolve(res);
    })
  );
};

const hasLogs = (tx_hash) => {
  const { logs } = tx_hash;
  if (typeof logs === 'undefined') {
    return 'LOGS_UNDEFINED';
  } else if (typeof logs !== 'object') {
    return 'LOGS_NOT_ARRAY';
  } else if (logs.length === 0) {
    return 'LOGS_EMPTY';
  } else if (typeof logs[0] !== 'object') {
    return 'LOG_NOT_OJECT';
  }else {
    return logs;
  }
}

contract("Token", accounts => {
  const owner = accounts[0];
  const spender = accounts[1];
  const destination = accounts[2];
  const checker = accounts[4];
  const value = ether(2);
  var token;

  beforeEach(async () => {
    token = await TestToken.new({ from: owner });
    // total supply is one billion tokens, using the ether helper here because decimals is 18
    const totalSupply = ether(100000000);
  });

  it("can be transferred when sent by owner", async () => {
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

  it("should have the right token supply", async () => {
    assert.ok(token);
    const balance = await token.balanceOf.call(accounts[0]);
    balance.should.be.bignumber.equal('1e+27')
  })

  it('should have a version', async () => {
    assert.ok(token);
    let version = await token.version.call({from: checker}).then(res => res)
    version.should.be.bignumber.equal('10')
  });

  it('should show the transfer event', async () => {
    assert.ok(token);
    let transferEvent = await token.transfer(accounts[1], 100000)
      .then(hasLogs)
      .then(logs => logs[0].event);
    transferEvent.should.equal('Transfer');
  })

  it('should have disable mint working', async () => {
    assert.ok(token);
    let mintEvent = await token.disableMinting({from:owner})
      .then(hasLogs)
      .then(logs => logs[0].event);
    mintEvent.should.equal('MintingDisabled');
  })

});


