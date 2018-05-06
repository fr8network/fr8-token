require('babel-register');
require('babel-polyfill');

const TestToken = artifacts.require("./Fr8NetworkToken.sol");
const ShipmentContract = artifacts.require("./ShipmentContract.sol");
const KeyValueStore = artifacts.require("./KeyValueStore.sol");
const Queue = artifacts.require("./Queue");

const connection = 'http://localhost:8545';
const uuidv4 = require('uuid/v4');
const Eth = require('web3-eth');
const Web3 = require('web3');

const web3 = new Web3(connection);
const eth = new Eth(connection);
web3.eth.getTransactionReceiptMined = require('../util/getTransactionReceiptMined.js');

async function doThings(store,bookedStatuses,owner) {
  return Promise.all(bookedStatuses.map((entity) => {
    const { entityAddress, entityData, entityStatus } = entity;
    return store.newEntity(entityAddress,entityData,entityStatus,{
      from: owner
    })
  }))
}

async function confirmNext(shipment,owner) {
  return shipment.increment({from:owner}).then(res => {
    const { tx } = res;
    console.log('tx:',tx);
    return web3.eth.getTransactionReceiptMined(tx)
      .then(cb => {
        
        return cb;
      })
  })
  .then(res => {


    const { data, topics} = res.logs[0];
    const myInputs = [{
      type: 'string',
      name: 'prevString',
      indexed: false
    },{
      type: 'string',
      name: 'currString',
      indexed: false
    }]
    const decoded = web3.eth.abi.decodeLog(myInputs,data,topics);
    console.log('decoded:',decoded);
    return res;
  })  
}

module.exports = async function(deployer, network, accounts) {
  const owner = accounts[0];
  let shipment;
  // const owner = "0x11f0cdddd75259b02418e5c116d904621632a590";
  await deployer.deploy(TestToken).then(async () => {
    const token = await TestToken.deployed();
    // return deployer.deploy(TokenSale, token.address, owner);
  });

  await deployer.deploy(ShipmentContract).then(async() => {
    shipment = await ShipmentContract.deployed();
    const bookedStatuses = getBookedStatuses().map((status,i) => {
      return {
        entityAddress: web3.utils.soliditySha3(status),
        entityData: i,
        entityStatus: status
      }
    })
    const gg = await doThings(shipment,bookedStatuses,owner);
    const count = await shipment.getEntityCount();
    console.log('count:',count);
    let q = [];
    q[0] = await shipment.queue.call(1);
    q[1] = await shipment.queue.call(2);
    q[2] = await shipment.queue.call(3);
    q[3] = await shipment.queue.call(4);
    console.log('q:',q);
    const opt2 = await shipment.optimisticNext();
    
    const next = await shipment.increment();
    const opt3 = await shipment.optimisticNext();
    
    const a =  await confirmNext(shipment,owner);

    await confirmNext(shipment,owner);
    await confirmNext(shipment,owner);
    const opt4 = await shipment.optimisticNext();
    // console.log('next:',next);
    const confirmed = await confirmNext(shipment,owner);

    const {logs } = confirmed;
    
  })

  // console.log('shipment:',shipment);

  // console.log('things[0]:',things[0]);
  // console.log('keyValueStore:',keyValueStore);
  // console.log('keyValueStore.address:',keyValueStore.address);
  // await deployer.deploy(ShipmentContract,keyValueStore.address).then(async () => {
  //   const shipmentContract = await ShipmentContract.deployed();
  //   const f = await shipmentContract.contract.keyValueStore.call()
  //   console.log('f:',f);
  //   const g = await shipmentContract.goNext.call();
  //   console.log('g:',g);
  //   const h = shipmentContract.getCurrent.call();
  //   console.log('h:',h);
    

  // })

};

function getBookedStatuses() {
  return [
    "CARRIER_FOUND", 
    "CARRIER_ACCEPTED_AND_ASSIGEND", 
    "AWAITING_PICKUP",
    "LOADING",
    "EN_ROUTE",
    "ARRIVED",
    "SHIPMENT_ACCEPTED",
    "DEPARTED",
    "COMPLETE "
  ];
}

// Running migration: 1_initial_migration.js
//   Deploying Migrations...
//   ... 0x76ff8562255be708abcd5de589637f2dc5c2020c6cd216fc6d1c53375e5a8841
//   Migrations: 0x2f0328d6359d698b364b5957dcb3775d34c0f9c9
// Saving successful migration to network...
//   ... 0x7e5c3ea936f9f41a739d719204d96989e25baacc424784e90d6f5431a8e5ca84
// Saving artifacts...
// Running migration: 2_deploy_contracts.js
//   Deploying TestToken...
//   ... 0x01bedc3a461110b5d5d1fdebe7fbbae2c0c19fc831a2331623ecfb54da3ee20d
//   TestToken: 0x2fee92f02e3835edc705167cec9c9eeac3a8db72
//   Deploying TokenSale...
//   ... 0x2fb781d434153528571bd0881da8f302a7e9ae2405bfac7f1537a3b559c9f6cf
//   TokenSale: 0x87e62428a43f9bcde1b38cb18bcbbe2ca3d3b942
// Saving successful migration to network...
//   ... 0x78a1738b334930128c2f97a247d6efc6d1cef6378e043bb60b14efef9a2e6787
