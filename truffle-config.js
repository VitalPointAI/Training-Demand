require('@babel/register');
require('@babel/polyfill');
require('dotenv').config();

let HDWalletProvider = require("truffle-hdwallet-provider");

//https://developers.skalelabs.com for SKALE documentation
//Provide your wallet private key
let privateKey = process.env.PRIVATE_KEY;

//Provide your SKALE endpoint address
let skale = process.env.SKALE_CHAIN;

module.exports = {
  
  networks: {
    
     development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8546,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
     },
     skale: {
      provider: () => new HDWalletProvider(privateKey, skale),
      gasPrice: 0,
      network_id: "*"
    }
  },
  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',
  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      // version: "0.5.1",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
      //  evmVersion: "byzantium"
      // }
    }
  }
}
